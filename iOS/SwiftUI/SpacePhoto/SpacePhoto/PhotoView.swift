//
//  PhotoView.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI

struct PhotoView: View {
    var photo: SpacePhoto
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: photo.url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(minWidth: 0, minHeight: 400)
            
            HStack {
                Text(photo.title)
                Spacer()
                SavePhotoButton(photo: photo)
            }
            .padding()
            .background(.thinMaterial)
        }
        .background(.thickMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .padding(.bottom, 0)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: SpacePhoto.testInstance1)
    }
}
