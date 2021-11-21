//
//  ContentView.swift
//  Draw
//
//  Created by 陈希 on 2021/11/20.
//

import SwiftUI

struct ContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var colorCycle = 0.0
    
    var customPath: some View {
        NavigationLink(destination: CustomPath()) {
            Text("Custom Triangle Path")
        }
    }
    
    var triangleView: some View {
        NavigationLink(destination: TriangleView()) {
            Text("Triangle Shape")
        }
    }
    
    var arcView: some View {
        NavigationLink(destination: ArcView()) {
            Text("Arc Shape")
        }
    }
    
    var flowerView: some View {
        NavigationLink(destination: FlowerView()) {
            Text("Flower")
        }
    }
    
    var colorCyclingCircle: some View {
        NavigationLink(destination: ColorCyclingCircleView()) {
            Text("Color Cycling Circle")
        }
    }
    
    var customBlendMode: some View {
        NavigationLink(destination: BlendMode()) {
            Text("Blend Mode")
        }
    }
    
    var trapezoid: some View {
        NavigationLink(destination: TrapezoidView()) {
            Text("Trapazoid")
        }
    }
    
    var checkerboard: some View {
        NavigationLink(destination: CheckerboardView()) {
            Text("Checkerboard")
        }
    }
    
    var spirograph: some View {
        NavigationLink(destination: CustomSpirograph()) {
            Text("Spirograph")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                customPath
                triangleView
                arcView
                flowerView
                colorCyclingCircle
                customBlendMode
                trapezoid
                checkerboard
                spirograph
            }
            .navigationTitle("Draw Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
//        VStack {
//            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
//                .fill(.red, style: FillStyle(eoFill: true))
////                .fill(.red)
////                .stroke(.red, lineWidth: 1)
//
//            Text("Offset")
//            Slider(value: $petalOffset, in: -40...40)
//                .padding([.horizontal, .bottom])
//
//            Text("Width")
//            Slider(value: $petalWidth, in: 0...100)
//                .padding(.horizontal)
//        }
//        Circle()
//            .strokeBorder(.blue, lineWidth: 10)
//        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
//            .strokeBorder(.blue, lineWidth: 40)
//            .frame(width: 300, height: 300)
//        Triangle()
//            .fill(.red)
//            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//            .frame(width: 300, height: 300)
//        path
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
