//
//  FilterListView.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import SwiftUI
import CoreImage

struct FilterListView: View {
    let filterList = CIFilter.filterNames(inCategory: nil)
    
    var body: some View {
        NavigationView {
            List(filterList, id: \.self) { filter in
                NavigationLink {
                    FilterDetailView(filter: filter)
                } label: {
                    Text(filter)
                }
            }
            .navigationTitle("Filter List")
        }
    }
}

struct FilterListView_Previews: PreviewProvider {
    static var previews: some View {
        FilterListView()
    }
}
