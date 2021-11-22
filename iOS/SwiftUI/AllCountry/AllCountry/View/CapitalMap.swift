//
//  CapitalMap.swift
//  AllCountry
//
//  Created by peak on 2021/11/15.
//

import SwiftUI
import MapKit

struct CapitalMap: View {
    @Binding var isShowCapitalMap: Bool
    var country: Country
    
    @AppStorage("CapitalMap.zoom")
    private var zoom: Double = 0.2
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: .constant(region))
                .navigationTitle(country.capital?.first ?? "Capital")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            isShowCapitalMap.toggle()
                        }
                    }
                }
        }
    }
        
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: country.capitalInfo!.latlng![0],
            longitude: country.capitalInfo!.latlng![1]
        )
    }
    
    var span: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: locationCoordinate, span: span)
    }
}

