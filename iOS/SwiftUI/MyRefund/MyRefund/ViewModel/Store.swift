//
//  Store.swift
//  MyRefund
//
//  Created by peak on 2022/1/28.
//

import Foundation
import StoreKit
import os

public enum StoreError: Error {
    case failedVerification
}

class Store: NSObject, ObservableObject {
    
    @Published private(set) var consumableProducts: [Product]
    
    @Published private(set) var purchasedTransaction = Set<Transaction>()
    @Published private(set) var historyTransaction: [Transaction] = []
    
    @Published public var isError: Bool = false
    @Published private(set) var errorMessage = ""
    
    @Published public var isRequestingProduct: Bool = false
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    private let productIdconfig: [String: String]
    
    private let logger: Logger
    
    override init() {
        logger = Logger(subsystem: "MyRefund", category: "MyRefund")
        
        
        if let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: path) {
            productIdconfig = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productIdconfig = [:]
        }
        
        consumableProducts = []
        super.init()
        
        self.featchData()
    }
    
    private func featchData() {
        updateListenerTask = listenForTransaction()

        self.log("Store init")

        Task {
            // Initialize the store by starting a product request.
            await requestProducts()
        }

        Task {
            await updateHistoryTransaction()
        }
    }
    
    public func log(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }
    
    deinit {
        log("Store deinit")
        updateListenerTask?.cancel()
    }
    
    private func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updatePurchasedTransaction(transaction)
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    private func updateHistoryTransaction() async {
        do {
            var iterator = Transaction.all.makeAsyncIterator()
            while let result = await iterator.next() {
                let transaction = try checkVerified(result)
                historyTransaction.append(transaction)
                print(transaction)
            }
        } catch {
            log("Error update history transaction: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            isError = true
        }
    }
    
    // MARK: Product Request
    
    @MainActor
    func requestProducts() async {
        isRequestingProduct = true
        do {
            let storeProducts = try await Product.products(for: productIdconfig.keys)
            if storeProducts.count == 0 {
                errorMessage = "Not found products from apple"
                isError = true
            }
            log("request [\(storeProducts.count)] products")
            
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    log("consumable product: \(product.description)")
                    consumableProducts.append(product)
                case .nonConsumable:
                    log("non consumable product: \(product.description)")
                case .autoRenewable:
                    log("auto renewable product: \(product.description)")
                default:
                    log("Unknown product")
                }
            }
        } catch {
            logger.error("Failed product reqeust: \(error.localizedDescription, privacy: .public)")
            errorMessage = error.localizedDescription
            isError = true
        }
        isRequestingProduct = false
    }
    
    // MARK: Purchase
    
    func purchase(_ product: Product) async throws -> Transaction? {
        log("begin purchase")
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            log("purchase success, begin verify")
            let transaction = try checkVerified(verification)
            log("check verified success: \(transaction.jsonRepresentation.toString())")
            let receipt = getAppStoreReceipt()
            log("receipt: \(receipt)")
            await updatePurchasedTransaction(transaction)
            
            // Always finish a transaction 
            await transaction.finish()
            
            return transaction
        case .userCancelled:
            log("user cancelled.")
            return nil
        case .pending:
            log("purchase pendings")
            return nil
        default:
            return nil
        }
    }
    
    /// Reference:
    /// https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/validating_receipts_with_the_app_store
    /// In the sandbox environment and in StoreKit Testing in Xcode, the app receipt is present only after the tester makes the first in-app purchase.
    private func getAppStoreReceipt() -> String {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return "no url"
        }
        log("appStoreReceiptURL: \(appStoreReceiptURL)")
        
        guard FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            refreshReceipt()
            return "file not exist"
        }
        do {
            log("appStoreReceiptURL path: \(appStoreReceiptURL.path)")
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            let receiptString = receiptData.base64EncodedString(options: [])
            log("receipt: \(receiptString)")
            return receiptString
        } catch {
            log("get app store receipt occur error: \(error.localizedDescription)")
        }
        return "error"
    }
    
    private func refreshReceipt() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verfication.
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            // If the transaction is verified, upwrap and return it.
            return safe
        }
    }
    
    @MainActor
    private func updatePurchasedTransaction(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            purchasedTransaction.insert(transaction)
        } else {
            purchasedTransaction.remove(transaction)
        }
    }
    
    // MARK: Refund
    
    func refund(transactionId: UInt64) async -> Bool {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        do {
            let status = try await Transaction.beginRefundRequest(for: transactionId, in: windowScene)
            switch status {
            case .userCancelled:
                log("user cancel")
                return false
            case .success:
                log("success")
                return true
            @unknown default:
                fatalError()
            }
        } catch {
            log("Occur error: \(error.localizedDescription)")
        }
        return true
    }
    
    func refund(transaction: Transaction) async -> Bool {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        
        do {
            log("begin refund request: \(transaction.debugDescription)")
            
//            let status = try await transaction.beginRefundRequest(in: windowScene)
            let status = try await Transaction.beginRefundRequest(for: 2000000679570979, in: windowScene)
            switch status {
            case .userCancelled:
                log("user cancel")
                return false
            case .success:
                log("success")
                return true
            @unknown default:
                fatalError()
            }
        } catch {
            log("Occur error: \(error.localizedDescription)")
        }
        return false
    }
}

extension Store: SKRequestDelegate {
    
    func requestDidFinish(_ request: SKRequest) {
        log("reqeust did finish")
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            log("url not exist")
            return
        }
        log("appStoreReceiptURL: \(appStoreReceiptURL)")
        
        guard FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            log("file not exist")
            return
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        log("request error: \(error)")
    }
}

extension Data {
    public func toString() -> String { String(decoding: self, as: UTF8.self) }
}
