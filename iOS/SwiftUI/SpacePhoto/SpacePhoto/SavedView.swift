//
//  SavedView.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI

struct SavedView: View {
    
    private var dataArray: [Data] {
        var result: [Data] = []
        if let resultArray = UserDefaults.standard.array(forKey: "SpacePhoto.dataArray") {
            result = resultArray as! [Data]
        }
        return result
    }
    var body: some View {
        List {
            ForEach(dataArray, id: \.self) { data in
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
//                    .background(.thickMaterial)
//                    .mask(RoundedRectangle(cornerRadius: 16))
//                    .padding(.bottom, 0)
            }
        }
//
//        AsyncImage(url: photo.url) { image in
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//        } placeholder: {
//            ProgressView()
//        }
//        .frame(minWidth: 0, minHeight: 400)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
