//
//  GroceryDeliveryAppApp.swift
//  GroceryDeliveryApp
//
//  Created by peak on 2023/8/30.
//

import SwiftUI

@main
struct GroceryDeliveryAppApp: App {
    
    init() {
        registerRemoteNotification()
    }
    
    private func registerRemoteNotification() {
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization { granted, error in
            if let error = error {
                print("request notification occur error: \(error)")
                return
            }
            print("request notification result: \(granted)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    guard let url = URLComponents(string: url.absoluteString) else { return }
                    if let courierNumber = url.queryItems?.first(where: { $0.name == "CourierNumber" })?.value {
                        print("Call Number: \(courierNumber)")
                    }
                }
        }
    }
}
