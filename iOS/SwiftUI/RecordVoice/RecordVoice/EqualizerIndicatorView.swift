//
//  Loading.swift
//  RecordVoice
//
//  Created by peak on 2022/3/22.
//

import SwiftUI

struct EqualizerIndicatorView: View {
    private let count: Int = 12
    
    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { geometry in
                ForEach(0..<self.count) { index in
                    EqualizerIndicatorItemView(index: index, count: count, size: geometry.size)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(width: 60, height: 30)
    }
}

struct EqualizerIndicatorItemView: View {
    
    let index: Int
    let count: Int
    let size: CGSize
    
    @State private var scale: CGFloat = 0
    
    var body: some View {
        let itemSize = size.width / CGFloat(count) / 2
        
        let animation = Animation
            .easeOut
            .delay(0.2)
            .repeatForever(autoreverses: true)
            .delay(Double(index) / Double(count) / 2)
        
        return Text("|")
            .frame(width: itemSize, height: size.height)
            .scaleEffect(x: 1, y: scale, anchor: .center)
            .onAppear {
                self.scale = 1
                withAnimation(animation) {
                    self.scale = 0.4
                }
            }
            .offset(x: 2 * itemSize * CGFloat(index) - size.width / 2 + itemSize / 2)
    }
}

struct EqualizerIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerIndicatorView()
            .previewLayout(.sizeThatFits)
    }
}
