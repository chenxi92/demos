//
//  CountryRow.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

struct CountryRow: View {
    var country: Country
    
    var computedName: String {
        (country.flag ?? "") + country.name.common
    }
    
    var body: some View {
        NavigationLink(
            destination: CountryDetail(country: country)) {
                VStack(alignment: .leading) {
                    Text(computedName)
                        .font(.title)
                    Text("Population \(country.population)")
                        .font(.caption)
                }
        }
    }
}

struct CountryRow_Previews: PreviewProvider {
    static var previews: some View {
        CountryRow(country: mockedCountry)
    }
}
