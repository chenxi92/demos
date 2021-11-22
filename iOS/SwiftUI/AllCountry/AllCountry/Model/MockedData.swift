//
//  MockedData.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import Foundation

let mockedCountry = Country(
    name: Country.CountryName(
        common: "China",
        official: "People's Republic of China"),
    cca2: "CN",
    ccn3: "156",
    cca3: "CHN",
    currencies: ["CNY": Country.Currency(name: "Chinese yuan", symbol: "¥")],
    capital: ["Beijing"],
    region: "Asia",
    borders: ["AFG","BTN","MMR","HKG","IND","KAZ","NPL","PRK","KGZ","LAO","MAC","MNG","PAK","RUS","TJK","VNM"],
    flag: "🇨🇳",
    population: 1402112000,
    flags: Country.Flags(
        png: "https://flagcdn.com/w320/cn.png",
        svg: "https://flagcdn.com/cn.svg"),
    capitalInfo: Country.CapitalInfo(latlng: [39.92, 116.38])
)
