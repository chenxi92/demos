//
//  FilterDetailView.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import SwiftUI

struct FilterDetailView: View {
    var filter: String
    
    var body: some View {
        if let ciFilter = CIFilter(name: filter) {
            ScrollView {
                Text(ciFilter.attributes.description)
            }
        } else {
            Text("Unknow filter!")
        }
    }
}

