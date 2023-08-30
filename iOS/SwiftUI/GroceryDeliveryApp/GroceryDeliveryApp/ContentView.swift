//
//  ContentView.swift
//  GroceryDeliveryApp
//
//  Created by peak on 2023/8/30.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    
    @State var vm = GroceryDeliverViewModel()
    @State private var activities: [Activity<DeliveryTrackAttributes>] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Create an activity to start a live activity")
                    
                    Button {
                        vm.createActivity()
                        activities = vm.allDeliveries()
                    } label: {
                        Text("Create Activity")
                            .font(.headline)
                    }
                    .tint(.green)
                    
                    Button {
                        activities = vm.allDeliveries()
                    } label: {
                        Text("List All Activities")
                            .font(.headline)
                    }
                    .tint(.green)
                    
                    Button {
                        vm.endAllActivity()
                        activities = vm.allDeliveries()
                    } label: {
                        Text("End All Activities")
                            .font(.headline)
                    }
                    .tint(.green)
                }
                
                Section {
                    Text("Live Activities")
                    if !activities.isEmpty {
                        ScrollView {
                            ForEach(activities, id: \.id) { activity in
                                ActivityItemView(activity: activity)
                            }
                        }
                    } else {
                        Text("No Live Activity")
                    }
                }
            }
        }
    }
    
    func ActivityItemView(activity: Activity<DeliveryTrackAttributes>) -> some View {
        HStack {
            Text(activity.courierName)
            Text(activity.deliverytime, style: .timer)
            
            Text("Update")
                .font(.headline)
                .foregroundColor(.mint)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .onTapGesture {
                    vm.update(activity: activity)
                    activities = vm.allDeliveries()
                }
            Text("End")
                .font(.headline)
                .foregroundColor(.red)
                .padding(.vertical, 5)
                .onTapGesture {
                    vm.end(activity: activity)
                    activities = vm.allDeliveries()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
