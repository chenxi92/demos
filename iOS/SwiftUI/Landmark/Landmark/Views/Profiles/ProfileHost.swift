//
//  ProfileHost.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            content
        }
        .padding()
    }
    
    var header: some View {
        HStack {
            if editMode?.wrappedValue == .active {
                Button("Cancel") {
                    draftProfile = modelData.profile
                    editMode?.animation().wrappedValue = .inactive
                }
            }
            Spacer()
            EditButton()
        }
    }
    
    @ViewBuilder
    var content: some View {
        if editMode?.wrappedValue == .inactive {
            ProfileSummary(profile: modelData.profile)
        } else {
            ProfileEditor(profile: $draftProfile)
                .onAppear() {
                    draftProfile = modelData.profile
                }
                .onDisappear() {
                    modelData.profile = draftProfile
                }
        }
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(ModelData())
    }
}
