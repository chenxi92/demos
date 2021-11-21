//
//  Arc.swift
//  Draw
//
//  Created by 陈希 on 2021/11/21.
//

import SwiftUI

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount = 0.0

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedend = endAngle - rotationAdjustment

        var path = Path()

        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            // insetAmount should applied to all edges.
            radius: rect.width / 2 - insetAmount,
            startAngle: modifiedStart,
            endAngle: modifiedend,
            clockwise: !clockwise
        )

        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}


struct ArcView: View {
    var body: some View {
        Arc(
            startAngle: .degrees(0),
            endAngle: .degrees(110),
            clockwise: true
        )
            .stroke(.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}

struct ArcView_Previews: PreviewProvider {
    static var previews: some View {
        ArcView()
    }
}
