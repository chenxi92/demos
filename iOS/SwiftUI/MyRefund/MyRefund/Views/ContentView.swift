//
//  ContentView.swift
//  MyRefund
//
//  Created by peak on 2022/1/28.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @StateObject var store: Store = Store()
    
    var body: some View {
        NavigationView {
            ProductListView()
                .environmentObject(store)
                .navigationTitle("Refund Demo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    myToolBarContent()
                }
                    
        }
    }
    
    @ToolbarContentBuilder
    func myToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                TransactionListView()
                    .environmentObject(store)
                    .navigationTitle("Transaction List")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("Refund")
                    .opacity(store.purchasedTransaction.isEmpty ? 0 : 1.0)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                HistoryListView()
                    .environmentObject(store)
                    .navigationTitle("Transaction History")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("History")
                    .opacity(store.historyTransaction.isEmpty ? 0 : 1.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
