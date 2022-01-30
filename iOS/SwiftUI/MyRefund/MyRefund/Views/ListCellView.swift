//
//  ListCellView.swift
//  MyRefund
//
//  Created by peak on 2022/1/28.
//

import SwiftUI
import StoreKit

struct ListCellView: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var messageTitle = ""
    @State var isShowAlert: Bool = false
    @State var isLoading: Bool = false
    
    let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                Text(product.description)
            }
            
            Spacer()
            
            buyButton
                .customButtonStyle(isSuccess: isPurchased)
                .disabled(isPurchased || isLoading)
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text(messageTitle), dismissButton: .default(Text("OK")))
        }
        .onChange(of: store.purchasedTransaction) { transactions in
            Task {
                if (transactions.first { $0.productID == product.id } != nil) {
                    isPurchased = true
                } else {
                    isPurchased = false
                }
            }
        }
    }
    
    var buyButton: some View {
        Button {
            Task {
                await buy()
            }
        } label: {
            if isLoading {
                HStack {
                    ProgressView()
                }
            } else {
                if isPurchased {
                    Text(Image(systemName: "checkmark"))
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text(product.displayPrice)
                        .bold()
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    func buy() async {
        do {
            isLoading = true
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
                messageTitle = "Purchase Success"
                isShowAlert = true
            }
            isLoading = false
        } catch StoreError.failedVerification {
            messageTitle = "Your purchase cound not be verified by the App Store"
            isShowAlert = true
            isLoading = false
        } catch {
            messageTitle = "Failed purchase for: \(product.id): \(error)"
            isShowAlert = true
            isLoading = false
        }
    }
}
