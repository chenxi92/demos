//
//  Triangle.swift
//  Draw
//
//  Created by 陈希 on 2021/11/21.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct TriangleView: View {
    var body: some View {
        Triangle()
            .stroke(
                .red,
                style: StrokeStyle(
                    lineWidth: 10,
                    lineCap: .round,
                    lineJoin: .round)
            )
            .frame(width: 300, height: 300)
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView()
    }
}
