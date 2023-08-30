//
//  DeliveryTrackWidgetLiveActivity.swift
//  DeliveryTrackWidget
//
//  Created by peak on 2023/8/30.
//

import ActivityKit
import WidgetKit
import SwiftUI


@available(iOSApplicationExtension 16.1, *)
struct DeliveryTrackWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryTrackAttributes.self) { context in
            // Create the presentation that appears on the Lock Screen and
            // as a banner on the Home Screen of devices that don't support the Dynamic Island.
            LockScreenView(context: context)
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
           dynamicIslandView(context: context)
        }
    }
    
    // MARK: - Dynamic Island
    
    func dynamicIslandView(context: ActivityViewContext<DeliveryTrackAttributes>) -> DynamicIsland {
        DynamicIsland {
            // Expanded UI goes here.  Compose the expanded UI through
            // various regions, like leading/trailing/center/bottom
            DynamicIslandExpandedRegion(.leading) {
                dynamicIslandExpandedLeadingView(context: context)
            }
            DynamicIslandExpandedRegion(.trailing) {
                dynamicIslandExpandedTrailingView(context: context)
            }
            DynamicIslandExpandedRegion(.center) {
                
            }
            DynamicIslandExpandedRegion(.bottom) {
                dynamicIslandExpandedBottomView(context: context)
            }
        } compactLeading: {
            VStack {
                Label {
                    Text("\(context.state.value)")
                } icon: {
                    Image("grocery")
                        .foregroundColor(.green)
                }
                .font(.caption2)
            }
        } compactTrailing: {
            Text(context.state.deliveryTime, style: .timer)
                .multilineTextAlignment(.center)
                .frame(width: 40)
                .font(.caption2)
        } minimal: {
            VStack(alignment: .center) {
                Text(context.state.deliveryTime, style: .timer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.caption2)
            }
        }
        .widgetURL(URL(string: "LiveActivities://?CourierNumber=123123"))
        .keylineTint(.cyan)
    }
    
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<DeliveryTrackAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.state.value)")
                    .font(.title2)
            } icon: {
                Image("grocery")
                    .foregroundColor(.green)
            }
            Text("items")
                .font(.title2)
        }
    }
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<DeliveryTrackAttributes>) -> some View {
        Label {
            Text(context.state.deliveryTime, style: .timer)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .monospacedDigit()
        } icon: {
            Image(systemName: "timer")
                .foregroundColor(.green)
        }
        .font(.title2)
    }
    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<DeliveryTrackAttributes>) -> some View {
        Link(destination: URL(string: "LiveActivities://?CourierNumber=123456")!) {
            Label("Call courier", systemImage: "phone")
        }
        .foregroundColor(.green)
    }
}

@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
    var context: ActivityViewContext<DeliveryTrackAttributes>
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .center) {
                    Text(context.state.courierName + " is on the way!")
                        .font(.headline)
                    Text("You ordered \(context.attributes.name) grocery items")
                        .font(.subheadline)
                    BottomLineView(time: context.state.deliveryTime)
                }
            }
        }
        .padding(15)
    }
}

struct BottomLineView: View {
    var time: Date
    var body: some View {
        HStack {
            Divider()
                .frame(width: 50, height: 10)
                .overlay(.gray.opacity(0.6))
                .cornerRadius(5)
            
            Image("delivery")
            
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .frame(height: 15)
                    .overlay(
                        Text(time, style: .timer)
                            .font(.system(size: 10))
                            .multilineTextAlignment(.center)
                    )
            }
            
            Image("home-address")
        }
    }
}

@available(iOSApplicationExtension 16.2, *)
struct DeliveryTrackWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = DeliveryTrackAttributes(name: "Apple")
    static let contentState = DeliveryTrackAttributes.ContentState(
        value: 3,
        courierName: "Mike",
        deliveryTime: Date() + 15
    )

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
