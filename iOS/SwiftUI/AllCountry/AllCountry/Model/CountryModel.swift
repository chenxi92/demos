//
//  CountryModel.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import Foundation
import SwiftUI

// API https://restcountries.com/#api-endpoints-v3-all
// Inspired by: https://github.com/nalexn/clean-architecture-swiftui?utm_source=gold_browser_extension

@MainActor
class CountryModel: ObservableObject {
    
    @Published private(set) var countrys: [Country] = []
    
    func updateCountrys() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://restcountries.com/v3.1/all")!)            
            var allCountry: [Country] = try JSONDecoder().decode(Array<Country>.self, from: data)
            allCountry.sort { $0.name.common < $1.name.common }
            countrys = allCountry
        }
        catch {
            print("occur error: \(error)")
        }
    }
    
    func queryCountry(by name: String) async -> Country? {
        do {
            let urlString = "https://restcountries.com/v3.1/name/"
            let url = URL(string: urlString + name)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let allCountry: [Country] = try JSONDecoder().decode(Array<Country>.self, from: data)
            if !allCountry.isEmpty {
                return allCountry.first
            }
        } catch {
            print("query country occur error: \(error)")
        }
        return nil
    }
    
}

extension CountryModel {
    func getCountry(from cca3: String) -> Country? {
        return countrys.filter { $0.cca3 == cca3 }.first
    }
}
