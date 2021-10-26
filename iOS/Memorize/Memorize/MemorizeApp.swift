//
//  MemorizeApp.swift
//  Memorize
//
//  Created by peak on 2021/10/25.
//


import SwiftUI

@main
struct MemorizeApp: App {
    
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}




