//
//  ColorCyclingCircle.swift
//  Draw
//
//  Created by 陈希 on 2021/11/21.
//

import SwiftUI

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(1..<steps) { value in
                Circle()
                    .inset(by: Double(value))
//                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        /// This tells SwiftUI it should render the contents of the view into an off-screen image before putting it back onto the screen as a single rendered output, which is significantly faster.
        /// Behind the scenes this is powered by Metal, which is Apple’s framework for working directly with the GPU for extremely fast graphics.
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingCircleView: View {
    @State private var colorCircle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: colorCircle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCircle) {
                Text("Amount")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
            .padding(.horizontal)
        }
    }
}

struct ColorCyclingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingCircleView()
    }
}
