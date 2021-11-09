//
//  ProfileSummary.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct ProfileSummary: View {
    @EnvironmentObject var modelData: ModelData
    var profile: Profile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            profileDescription
            Divider()
            completedBadges
            Divider()
            recentHikes
        }
    }
    
    @ViewBuilder
    var profileDescription: some View {
        Text(profile.username)
            .bold()
            .font(.title)
        
        Text("Notifications: \(profile.prefersNotifications ? "On" : "Off")")
        Text("Seasonal Photos: \(profile.seasonalPhoto.rawValue)")
        Text("Goal Date: ") + Text(profile.goalDate, style: .date)
    }
    
    var completedBadges: some View {
        VStack(alignment: .leading) {
            Text("Completed Badges")
                .font(.headline)
            
            ScrollView(.horizontal) {
                HStack {
                    HikeBadge(name: "First Hike")
                    HikeBadge(name: "Earth Day")
                        .hueRotation(Angle(degrees: 90))
                    HikeBadge(name: "Tenth Hike")
                        .grayscale(0.50)
                        .hueRotation(Angle(degrees: 45))
                }
                .padding(.bottom)
            }
        }
    }
    
    var recentHikes: some View {
        VStack(alignment: .leading) {
            Text("Recent Hikes")
                .font(.headline)
            
            HikeView(hike: modelData.hikes[0])
        }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
            .environmentObject(ModelData())
    }
}
