//
//  DeliveryTrackAttributes.swift
//  GroceryDeliveryApp
//
//  Created by peak on 2023/8/30.
//

import Foundation
import ActivityKit

struct DeliveryTrackAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
        
        var courierName: String
        
        var deliveryTime: Date
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

@available(iOSApplicationExtension 16.1, *)
extension Activity where ContentState == DeliveryTrackAttributes.ContentState {
    var courierName: String {
        if #available(iOS 16.2, *) {
            return content.state.courierName
        } else {
            return contentState.courierName
        }
    }
    
    var deliverytime: Date {
        if #available(iOS 16.2, *) {
            return content.state.deliveryTime
        } else {
            return contentState.deliveryTime
        }
    }
}
