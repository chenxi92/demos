//
//  DetailRow.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

struct DetailRow: View {
    let leftText: String
    let rightText: String?
    
    var body: some View {
        HStack {
            Text(leftText)
                .font(.callout)
            Spacer()
            if rightText != nil {
                Text(rightText!)
                    .font(.headline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
    }
}
