//
//  HistoryListView.swift
//  MyRefund
//
//  Created by peak on 2022/1/29.
//

import SwiftUI
import StoreKit

struct HistoryListView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        List {
            ForEach(store.historyTransaction) { transaction in
                HistoryListCellView(transaction: transaction)
                    .foregroundColor(.primary)
            }
        }
    }
}


