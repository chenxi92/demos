//
//  ContentView.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import SwiftUI

struct ContentView: View {
    @State var showFilterListUI = false
    let paintings = Gallery().paintings
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.showFilterListUI.toggle()
                } label: {
                    Text("Filter List")
                }
                .padding(.trailing)
                .sheet(isPresented: $showFilterListUI) {
                    FilterListView()
                }
            }
            
            PaintingWall(paintings: paintings)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
