//
//  Country.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import Foundation

struct Country {
    
    var name: CountryName
    struct CountryName: Codable {
        var common: String
        var official: String
    }
    
    var cca2: String
    var ccn3: String?
    var cca3: String
    
    var currencies: [String: Currency]?
    struct Currency: Codable, Identifiable {
        var name: String
        var symbol: String?
        var id: String { name + (symbol ?? "")}
    }

    var capital: [String]?
    var region: String
    var borders: [String]?
    var flag: String?
    var population: Int
    
    var flags: Flags
    
    struct Flags: Codable {
        var png: String
        var svg: String
    }
    
    var capitalInfo: CapitalInfo?
    struct CapitalInfo: Codable {
        var latlng: [Double]?
    }
}

extension Country: Codable {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Country.self, from: data)
    }
}

extension Country: Identifiable {
    var id: String { cca2 + cca3 + name.official }
}


