//
//  AllCountryApp.swift
//  AllCountry
//
//  Created by peak on 2021/11/12.
//

import SwiftUI

@main
struct AllCountryApp: App {
    @StateObject private var model = CountryModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
