//
//  ProfileEditor.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
    
    var body: some View {
        List {
            nameRow
            notificationRow
            seasonRow
            dateRow
        }
    }
    
    var nameRow: some View {
        HStack {
            Text("Username").bold()
            Divider()
            TextField("Username", text: $profile.username)
        }
    }
    
    var notificationRow: some View {
        Toggle(isOn: $profile.prefersNotifications) {
            Text("Enable Notifications").bold()
        }
    }
    
    var seasonRow: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Season Photo").bold()
            
            Picker("Season Photos", selection: $profile.seasonalPhoto) {
                ForEach(Profile.Season.allCases) { season in
                    Text(season.rawValue).tag(season)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var dateRow: some View {
        DatePicker(selection: $profile.goalDate, in: dateRange, displayedComponents: .date) {
            Text("Goal Date").bold()
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
