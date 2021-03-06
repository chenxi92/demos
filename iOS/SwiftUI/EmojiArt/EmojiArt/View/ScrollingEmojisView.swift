//
//  ScrollingEmojiView.swift
//  EmojiArt
//
//  Created by ιεΈ on 2021/11/7.
//

import SwiftUI

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag {
                            NSItemProvider(object: emoji as NSString)
                        }
                }
            }
        }
    }
}

struct ScrollingEmojisView_Previews: PreviewProvider {
    static var previews: some View {
        let emojis = "ππππππππ»πππππππβοΈπ«π¬π©ππΈπ²ππΆβ΅οΈπ€π₯π³β΄π’ππππππππΊπ"
        ScrollingEmojisView(emojis: emojis)
    }
}
