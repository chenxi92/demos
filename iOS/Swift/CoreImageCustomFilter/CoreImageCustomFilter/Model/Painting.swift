//
//  Painting.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import Foundation

struct Painting: Decodable, Identifiable {
    let name: String
    let image: String
    var id = UUID()
    
    enum CodingKeys: CodingKey {
        case name
        case image
    }
}
