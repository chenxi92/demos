//
//  ContentView.swift
//  MenuBarApp
//
//  Created by peak on 2022/9/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        List {
            ForEach(1...100, id: \.self) { index in
                Text("Hello World \(index)")
                    .padding()
                    .background(Color.mint)
            }
            .padding()
        }
        .frame(minWidth: 500, minHeight: 600)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
