//
//  Content.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI

// demo from WWDC: Discover concurrency in SwiftUI
// https://developer.apple.com/videos/play/wwdc2021/10019/

struct Content: View {
    var body: some View {
        TabView {
            CatalogView()
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("Random")
            }
            SavedView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Saved")
                }
        }
        .font(.headline)
    }
}

struct Content_Previews: PreviewProvider {
    static var previews: some View {
        Content()
    }
}
