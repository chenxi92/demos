//
//  TransactionListView.swift
//  MyRefund
//
//  Created by peak on 2022/1/29.
//

import SwiftUI
import StoreKit


struct TransactionListView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        List {
            ForEach(Array(store.purchasedTransaction)) { transaction in
                TransactionListCellView(transaction: transaction)
            }
        }
    }
}

