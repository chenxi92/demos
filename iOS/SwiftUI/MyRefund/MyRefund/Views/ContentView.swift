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
        .alert(isPresented: $store.isError) {
            Alert(title: Text(store.errorMessage), dismissButton: .default(Text("OK")))
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
            }
            .disabled(store.purchasedTransaction.isEmpty)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
//            NavigationLink {
//                HistoryListView()
//                    .environmentObject(store)
//                    .navigationTitle("Transaction History")
//                    .navigationBarTitleDisplayMode(.inline)
//            } label: {
//                Text("History")
//            }
//            .disabled(store.historyTransaction.isEmpty)
                
            Button {
                Task {
                    await store.refund(transactionId: 2000000679577859)
                }
            } label: {
                Text("Test Refund")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
