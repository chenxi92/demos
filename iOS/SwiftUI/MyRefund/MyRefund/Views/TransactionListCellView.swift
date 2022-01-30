//
//  TransactionListCellView.swift
//  MyRefund
//
//  Created by peak on 2022/1/29.
//

import SwiftUI
import StoreKit

struct TransactionListCellView: View {
    let transaction: StoreKit.Transaction
    
    init(transaction: StoreKit.Transaction) {
        self.transaction = transaction
    }
    
    @EnvironmentObject var store: Store
    
    @State private var isLoading: Bool = false
    @State private var isRefunded: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(transaction.originalID)")
                    .font(.headline)
                
                Text(transaction.productID)
                    .font(.caption)
            }
            
            Spacer()
            
            refundButton
                .customButtonStyle(isSuccess: isRefunded)
                .disabled(isLoading || isRefunded)
        }
    }
    
    var refundButton: some View {
        Button {
            Task {
                await doRefund()
            }
        } label: {
            if isLoading {
                ProgressView()
            } else {
                if isRefunded {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text("Refund")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    func doRefund() async {
        isLoading = true
        let result = await store.refund(transaction: transaction)
        isLoading = false
        isRefunded = result
    }
}

