//
//  CountryList.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

struct CountryList: View {
    @EnvironmentObject private var model: CountryModel
    @State private var searchText = ""
        
    var filteredData: [Country] {
        if searchText.isEmpty {
            return model.countrys
        } else {
            return model.countrys.filter { country in
                country.name.common.hasPrefix(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredData) { country in
                CountryRow(country: country)
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        .navigationTitle("Countries")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct CountryList_Previews: PreviewProvider {
    static var previews: some View {
        CountryList()
    }
}
