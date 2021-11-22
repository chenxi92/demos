//
//  ContentView.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: CountryModel
    
    var body: some View {
        NavigationView {
            if model.countrys.isEmpty {
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                CountryList()
            }
        }
        .task {
            await model.updateCountrys()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
