//
//  DeliveryTrackWidgetBundle.swift
//  DeliveryTrackWidget
//
//  Created by peak on 2023/8/30.
//

import WidgetKit
import SwiftUI

@main
struct DeliveryTrackWidgetBundle: WidgetBundle {
    var body: some Widget {
        DeliveryTrackWidget()
        if #available(iOS 16.1, *) {
            DeliveryTrackWidgetLiveActivity()            
        }
    }
}
