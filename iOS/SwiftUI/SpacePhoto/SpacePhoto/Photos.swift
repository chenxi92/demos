//
//  Photos.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI
import Foundation

@MainActor
class Photos: ObservableObject {
    @Published private(set) var items: [SpacePhoto] = []
    
    func updateItems() async {
        let fetched = await fetchPhotos()
        print("fetched \(fetched.count) items")
        items = fetched
    }
    
    func fetchPhotos() async -> [SpacePhoto] {
        var downloaded: [SpacePhoto] = []
        for date in randomPhotoDates() {
            let url = SpacePhoto.requestFor(date: date)
            if let photo = await fetchPhoto(from: url) {
                downloaded.append(photo)
            }
            downloaded.append(mookData())
        }
        return downloaded
    }
    
    private func mookData() -> SpacePhoto {
        let random = Int.random(in: 1...6)
        if random == 1 {
            return SpacePhoto.testInstance1
        } else if random == 2 {
            return SpacePhoto.testInstance2
        } else if random == 3 {
            return SpacePhoto.testInstance3
        } else if random == 4 {
            return SpacePhoto.testInstance4
        } else if random == 5 {
            return SpacePhoto.testInstance5
        } else {
            return SpacePhoto.testInstance6
        }
    }
    
    func fetchPhoto(from url: URL) async -> SpacePhoto? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try SpacePhoto(data: data)
        } catch {
//            print("fetch photo error: \(error)")
            return nil
        }
    }
    
    func randomPhotoDates() -> [Date] {
        let random = Int.random(in: 1...6)
        return Array(repeating: Date.now, count: random)
    }
}
