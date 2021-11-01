//
//  ContentView.swift
//  WatchLandMarks Extension
//
//  Created by peak on 2021/11/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
