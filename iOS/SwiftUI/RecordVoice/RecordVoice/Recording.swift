//
//  Recording.swift
//  RecordVoice
//
//  Created by peak on 2022/3/21.
//

import Foundation

struct Recording: Codable {
    var fileURL: URL
    var createdAt: Date
    var duration: Int
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        self.createdAt = Date.now
        self.duration = 0
    }
}
