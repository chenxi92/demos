//
//  CategoryRow.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Landmark]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .headerStyle()
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items, content: CategoryItem.init)
                }
            }
            .frame(height: 185)
        }
    }
}

extension Text {
    func headerStyle() -> some View {
        self.font(.headline).padding(.leading, 15).padding(.top, 5)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static let landmarks = ModelData().landmarks
    
    static var previews: some View {
        CategoryRow(
            categoryName: landmarks[0].category.rawValue,
            items: Array(landmarks.prefix(4))
        )
    }
}
