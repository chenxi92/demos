//
//  CountryDetail.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

struct CountryDetail: View {
    @EnvironmentObject private var model: CountryModel
    @State private var isShowCapitalMap: Bool = false
    var country: Country
    
    var body: some View {
        List {
            flagViwe
            baseInfo
            if country.currencies != nil {
                let currencyList = country.currencies!.map { $0.1 }
                currenciesSection(currencies: currencyList)
            }
            
            if country.borders != nil {
                neighborsSection(borders: country.borders!)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(country.name.official)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowCapitalMap) {
            CapitalMap(isShowCapitalMap: $isShowCapitalMap, country: country)
        }
    }
    
    var flagViwe: some View {
        HStack {
            Spacer()
            
            AsyncImage(url: URL(string: country.flags.png)!) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 80)
            
            Spacer()
        }
        .onTapGesture {
            if let capitalInfo = country.capitalInfo, capitalInfo.latlng != nil {
                isShowCapitalMap.toggle()
            }
        }
    }
    
    var baseInfo: some View {
        Section(header: Text("Base Info")) {
            DetailRow(leftText: "Code", rightText: country.cca3)
            DetailRow(leftText: "Population", rightText: String(country.population))
            DetailRow(leftText: "Capital", rightText: country.capital?.first ?? "No")
        }
    }
    
    func currenciesSection(currencies: [Country.Currency]) -> some View {
        Section(header: Text("Currencies")) {
            ForEach(currencies) { currency in
                DetailRow(leftText: currency.name, rightText: currency.symbol ?? "")
            }
        }
    }
    
    func neighborsSection(borders: [String]) -> some View {
        Section(header: Text("Neighboring countries")) {
            ForEach(borders, id: \.self) { border in
                if let borderCountry = model.getCountry(from: border) {
                    NavigationLink(destination: CountryDetail(country: borderCountry)) {
                        DetailRow(leftText: borderCountry.name.common, rightText: nil)
                    }
                }
            }
        }
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: mockedCountry)
    }
}
