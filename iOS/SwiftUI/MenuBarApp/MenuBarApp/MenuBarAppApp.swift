//
//  MenuBarAppApp.swift
//  MenuBarApp
//
//  Created by peak on 2022/9/21.
//

import SwiftUI

@main
struct MenuBarAppApp: App {
     
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: .zero)
        }
    }
}


