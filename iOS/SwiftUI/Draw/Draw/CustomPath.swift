//
//  Path.swift
//  Draw
//
//  Created by 陈希 on 2021/11/21.
//

import SwiftUI

struct CustomPath: View {
    
    var body: some View {
        VStack {
            Path { path in
                path.move(to: CGPoint(x: 200, y: 100))
                path.addLine(to: CGPoint(x: 100, y: 300))
                path.addLine(to: CGPoint(x: 300, y: 300))
                path.addLine(to: CGPoint(x: 200, y: 100))
    //            path.closeSubpath()
            }
//            .fill(.red)
//            .stroke(.blue, lineWidth: 10)
            .stroke(.blue,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round,
                        lineJoin: .round)
                    )
        }
    }

}

struct CustomPath_Previews: PreviewProvider {
    static var previews: some View {
        CustomPath()
    }
}
