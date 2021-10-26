//
//  ContentView.swift
//  Memorize
//
//  Created by peak on 2021/10/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
//    @ViewBuilder
//    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
//        if card.isMatched && !card.isFaceUp {
//            Rectangle().opacity(0)
//        } else {
//            CardView(card: card)
//                .padding(4)
//                .onTapGesture {
//                    game.choose(card)
//                }
//        }
//    }
    
//    var body: some View {
//        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
//            CardView(card: card)
//                .padding(4)
//                .onTapGesture {
//                    game.choose(card)
//                }
//        }
//    }
    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
//                    ForEach(game.cards) { card in
//                        CardView(card)
//                            .aspectRatio(2/3, contentMode: .fit)
//                            .onTapGesture {
//                                game.choose(card)
//                            }
//                    }
//                })
//            }
//        }
//        .foregroundColor(.red)
//        .padding(.horizontal)
//    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
//    init(_ card: EmojiMemoryGame.Card) {
//        self.card = card
//    }
    
//    var body: some View {
//        ZStack {
//            let shape = RoundedRectangle(cornerRadius: 20)
//            if card.isFaceUp {
//                shape.fill().foregroundColor(.white)
//                shape.strokeBorder(lineWidth: 3)
//                Text(card.content).font(.largeTitle)
//            } else if card.isMatched {
//                shape.opacity(0)
//            } else {
//                shape.fill()
//            }
//        }
//    }
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 160-90))
                        .padding(5).opacity(0.5)
                    Text(card.content)
                        .font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstant.fontScale)
    }
    
    private struct DrawingConstant {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
