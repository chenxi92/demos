//
//  LandmarkApp.swift
//  WatchLandMarks Extension
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

@main
struct LandmarkApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
