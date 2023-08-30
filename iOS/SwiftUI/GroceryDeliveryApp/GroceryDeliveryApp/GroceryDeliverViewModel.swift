//
//  GroceryDeliverViewModel.swift
//  GroceryDeliveryApp
//
//  Created by peak on 2023/8/30.
//

import SwiftUI
import ActivityKit

class GroceryDeliverViewModel {
    
    func createActivity() {
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            print("Use not enable Live Activity")
            return
        }
        let attributes = DeliveryTrackAttributes(name: "Apple")
        let contentState = DeliveryTrackAttributes.ContentState(
            value: 12,
            courierName: "Mike",
            deliveryTime: .now + 120
        )
        
        do {
            if #available(iOS 16.2, *) {
                _ = try Activity<DeliveryTrackAttributes>.request(attributes: attributes, content: ActivityContent(state: contentState, staleDate: nil), pushType: .token)
            } else {
                _ = try Activity<DeliveryTrackAttributes>
                    .request(attributes: attributes, contentState: contentState, pushType: .token)
            }
        } catch {
            print("occur error: \(error.localizedDescription)")
        }
    }
    
    func update(activity: Activity<DeliveryTrackAttributes>) {
        Task {
            let updatedStatus = DeliveryTrackAttributes.ContentState(value: 13, courierName: "Adam", deliveryTime: .now + 60)
            await activity.update(using: updatedStatus)
        }
    }
    
    func end(activity: Activity<DeliveryTrackAttributes>) {
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    func endAllActivity() {
        Activity<DeliveryTrackAttributes>.activities.forEach { end(activity: $0) }
    }
    
    func allDeliveries() -> [Activity<DeliveryTrackAttributes>] {
        if #available(iOS 16.2, *) {
            return Activity<DeliveryTrackAttributes>.activities.sorted {
                $0.content.state.deliveryTime > $1.content.state.deliveryTime
            }
        } else {
            return Activity<DeliveryTrackAttributes>.activities.sorted {
                $0.contentState.deliveryTime > $1.contentState.deliveryTime
            }
        }
    }
}
