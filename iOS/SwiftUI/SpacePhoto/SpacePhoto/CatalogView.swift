//
//  CatalogView.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var photos = Photos()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(photos.items) { item in
                    PhotoView(photo: item)
                        .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Catalog")
            .listStyle(.plain)
            .refreshable {
                await photos.updateItems()
            }
        }
        .task {
            await photos.updateItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
