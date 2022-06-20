//
//  Gallery.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import Foundation

struct Gallery {
    let paintings: [Painting] = {
        guard let paintingJson = Bundle.main.url(forResource: "paintings", withExtension: "json") else {
            fatalError("unable to load paintings")
        }
        
        do {
            let jsonData = try Data(contentsOf: paintingJson)
            return try JSONDecoder().decode([Painting].self, from: jsonData)
        } catch {
            fatalError("unable to parse the painting json: \(error)")
        }
    }()
}
