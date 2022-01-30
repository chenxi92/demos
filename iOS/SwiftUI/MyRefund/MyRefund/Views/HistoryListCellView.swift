//
//  HistoryListCellView.swift
//  MyRefund
//
//  Created by peak on 2022/1/29.
//

import SwiftUI
import StoreKit

struct HistoryListCellView: View {
    let transaction: StoreKit.Transaction
    init(transaction: StoreKit.Transaction) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Original ID: \(transaction.originalID)")
                .font(.headline)
            Text("Product ID:" + transaction.productID)
                .font(.caption)
            
            Text("Purchase Date:" + transaction.purchaseDate.asString())
                .font(.subheadline)
            
            if let date = transaction.revocationDate,
                let reasone = transaction.revocationReason {
                Text("Refunded Time: \(date.asString())")
                    .font(.subheadline)
                
                switch reasone {
                case .developerIssue:
                    Text("Refunded Reason: Developer Issue")
                        .font(.title2)
                        .foregroundColor(.red)
                case .other:
                    Text("Refunded Reason: Other Issue")
                        .font(.title2)
                        .foregroundColor(.purple)
                default:
                    Text("Refunded Reason: Unknown")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

extension Date {
    func asString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
