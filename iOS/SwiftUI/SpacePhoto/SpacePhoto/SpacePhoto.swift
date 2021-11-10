//
//  SpacePhoto.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import Foundation
import SwiftUI

struct SpacePhoto {
    var title: String
    var description: String
    var date: Date
    var url: URL
}

extension SpacePhoto: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case date
        case url
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(SpacePhoto.dateFormatter)
        self = try decoder.decode(SpacePhoto.self, from: data)
    }
}

extension SpacePhoto: Identifiable {
    var id: Date { date }
}

extension SpacePhoto {
    static let urlTemplate = "https://example.com/photo"
    static let dateFormat = "yyyy-MM-dd"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func requestFor(date: Date) -> URL {
        let dateString = SpacePhoto.dateFormatter.string(from: date)
        return URL(string: "\(SpacePhoto.urlTemplate)&date=\(dateString)")!
    }
    
    private static func parseDate(fromContainer container: KeyedDecodingContainer<CodingKeys>) throws -> Date {
        let dateString = try container.decode(String.self, forKey: .date)
        guard let result = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        return result
    }
    
    private var dateString: String {
        Self.dateFormatter.string(from: date)
    }
}

extension SpacePhoto {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = try Self.parseDate(fromContainer: container)
        url = try container.decode(URL.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(dateString, forKey: .date)
        try container.encode(url, forKey: .url)
    }
}

extension SpacePhoto {
    func save() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            var dataArray = UserDefaults.standard.array(forKey: "SpacePhoto.dataArray") as? [Data]
            if dataArray == nil {
                dataArray = []
            }
            dataArray = dataArray!.filter { $0 != data }
            dataArray!.append(data)
            UserDefaults.standard.set(dataArray, forKey: "SpacePhoto.dataArray")
            print("save success: \(url.absoluteString) ")
        } catch {
            print("save photo error: \(error)")
        }
    }
}


extension SpacePhoto {
    static var testInstance1: SpacePhoto {
        return SpacePhoto(
            title: "Number 1",
            description: "node",
            date: Date.now,
            url: URL(string: "https://19yw4b240vb03ws8qm25h366-wpengine.netdna-ssl.com/wp-content/uploads/11-Space-APIs-Because-Space-is-Neat.jpeg")!
        )
    }
    
    static var testInstance2: SpacePhoto {
        return SpacePhoto(
            title: "Number 2",
            description: "number is perple",
            date: Date.now.addingTimeInterval(2),
            url: URL(string: "https://images.unsplash.com/photo-1537429149818-2d0e3e20857b?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNwYWNlJTIwYmFja2dyb3VuZHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")!
        )
    }
    
    static var testInstance3: SpacePhoto {
        return SpacePhoto(
            title: "Number 3",
            description: "lightning",
            date: Date.now.addingTimeInterval(3),
            url: URL(string: "https://media.istockphoto.com/photos/background-of-galaxy-and-stars-picture-id1035676256?b=1&k=20&m=1035676256&s=170667a&w=0&h=NOtiiFfDhhUhZgQ4wZmHPXxHvt3RFVD-lTmnWCeyIG4=")!
        )
    }
    
    static var testInstance4: SpacePhoto {
        return SpacePhoto(
            title: "Number 4",
            description: "with moon",
            date: Date.now.addingTimeInterval(4),
            url: URL(string: "https://images.unsplash.com/photo-1559657693-e816ff3bd9af?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8c3BhY2UlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")!
        )
    }
    
    static var testInstance5: SpacePhoto {
        return SpacePhoto(
            title: "Number 5",
            description: "mountion",
            date: Date.now.addingTimeInterval(5),
            url: URL(string: "https://images.unsplash.com/photo-1560232216-3d0dcb7afd5f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8c3BhY2UlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")!
        )
    }
    
    static var testInstance6: SpacePhoto {
        return SpacePhoto(
            title: "Number 6",
            description: "start",
            date: Date.now.addingTimeInterval(4),
            url: URL(string: "https://images.unsplash.com/photo-1537420327992-d6e192287183?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8c3BhY2UlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")!
        )
    }
}
