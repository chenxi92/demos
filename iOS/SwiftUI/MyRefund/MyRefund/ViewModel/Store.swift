//
//  Store.swift
//  MyRefund
//
//  Created by peak on 2022/1/28.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    
    @Published private(set) var consumableProducts: [Product]
    
    @Published private(set) var purchasedTransaction = Set<Transaction>()
    @Published private(set) var historyTransaction: [Transaction] = []
    
    @Published public var isError: Bool = false
    @Published private(set) var errorMessage = ""
    
    @Published public var isRequestingProduct: Bool = false
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    private let productIdconfig: [String: String]
    
    init() {
        if let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: path) {
            productIdconfig = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productIdconfig = [:]
        }
        
        consumableProducts = []
        
        updateListenerTask = listenForTransaction()
        
        Task {
            // Initialize the store by starting a product request.
            await requestProducts()
        }
        
        Task {
            await updateHistoryTransaction()
        }
    }
    
    deinit {
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
            print("Error update history transaction: \(error)")
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
            print("request [\(storeProducts.count)] products")
            
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    print("consumable product: \(product.debugDescription)")
                    consumableProducts.append(product)
                case .nonConsumable:
                    print("non consumable product: \(product)")
                case .autoRenewable:
                    print("auto renewable product: \(product)")
                default:
                    print("Unknown product")
                }
            }
        } catch {
            print("Failed product reqeust: \(error)")
            errorMessage = error.localizedDescription
            isError = true
        }
        isRequestingProduct = false
    }
    
    // MARK: Purchase
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
           
            await updatePurchasedTransaction(transaction)
            
            // Always finish a transaction 
            await transaction.finish()
            
            return transaction
        case .userCancelled:
            print("user cancelled.")
            return nil
        case .pending:
            print("purchase pendings")
            return nil
        default:
            return nil
        }
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
    
    func refund(transaction: Transaction) async -> Bool {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        
        do {
            print("begin refund request: \(transaction.debugDescription)")
            
            let status = try await transaction.beginRefundRequest(in: windowScene)
            
            switch status {
            case .userCancelled:
                print("user cancel")
                return false
            case .success:
                print("success")
                return true
            @unknown default:
                fatalError()
            }
        } catch {
            print("Occur error: \(error)")
        }
        return false
    }
}
