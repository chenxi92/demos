//
//  ProductListView.swift
//  MyRefund
//
//  Created by peak on 2022/1/29.
//

import SwiftUI
import StoreKit

struct ProductListView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Product List")
                    .bold()
                    .font(.title2)

                Spacer()
            }
            .padding()
            
            List {
                ForEach(store.consumableProducts) {product in
                    ListCellView(product: product)
                        .environmentObject(store)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}
