//
//  SavePhotoButton.swift
//  SpacePhoto
//
//  Created by peak on 2021/11/10.
//

import SwiftUI

struct SavePhotoButton: View {
    var photo: SpacePhoto
    @State private var isSaving = false
    var body: some View {
        Button {
            Task {
                isSaving = true
                await photo.save()
                isSaving = false
            }
        } label: {
            Text("Save")
                .opacity(isSaving ? 0 : 1)
                .overlay {
                    if isSaving {
                        ProgressView()
                    }
                }
        }
        .disabled(isSaving)
        .buttonStyle(.bordered)

    }
}

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        SavePhotoButton(photo: SpacePhoto.testInstance1)
    }
}
