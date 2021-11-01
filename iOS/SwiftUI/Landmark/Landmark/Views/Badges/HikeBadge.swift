//
//  HikeBadge.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct HikeBadge: View {
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            Badge()
                .frame(width: 300, height: 300, alignment: .center)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100, alignment: .center)
            
            Text(name)
                .font(.caption)
                .accessibilityLabel("Badge for \(name)")
        }
    }
}

struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Preview Testing")
    }
}
