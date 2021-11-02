//
//  MapView.swift
//  Landmark
//
//  Created by peak on 2021/11/1.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
//    @State private var region = MKCoordinateRegion()
    
    @AppStorage("MapView.zoom")
    private var zoom: Zoom = .medium
    
    enum Zoom: String, CaseIterable, Identifiable {
        case near = "Near"
        case medium = "Medium"
        case far = "Far"
        
        var id: Zoom { self }
    }
    
    var delta: CLLocationDegrees {
        switch zoom {
        case .near:
            return 0.02
        case .medium:
            return 0.2
        case .far:
            return 2
        }
    }
    
    var body: some View {
//        Map(coordinateRegion: $region)
//            .onAppear {
//                setRetion(coordinate)
//            }
        Map(coordinateRegion: .constant(region))
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
    }
    
//    private func setRetion(_ coordinate: CLLocationCoordinate2D) {
//        region = MKCoordinateRegion(
//            center: coordinate,
//            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
//        )
//    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
