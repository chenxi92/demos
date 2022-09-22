//
//  PopoverView.swift
//  MenuBarApp
//
//  Created by peak on 2022/9/21.
//

import SwiftUI

struct PopoverView: View {
    @State var currentTab: String = "Feed"
    @Namespace var animation
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        VStack(spacing: 0) {
            customSegmentedControl()
                
            Spacer()
            
            VStack {
                Text("Hello world, select tab: \(currentTab)")
            }
            
            Spacer()
            
            
            Button {
                appDelegate.showMainWindow()
            } label: {
                Text("Open Main Content")
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical)
            
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
                    .foregroundColor(.red)
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding()
        .frame(width: 320, height: 450)
    }
    
    @ViewBuilder
    func customSegmentedControl() -> some View {
        HStack {
            ForEach(["Feed", "Favorite"], id: \.self) { tab in
                Text(tab)
                    .fontWeight(currentTab == tab ? .semibold : .regular)
                    .foregroundColor(currentTab == tab ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background {
                        if currentTab == tab {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.mint)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            currentTab = tab
                        }
                    }
            }
        }
        .padding(2)
        .background {
            Color.secondary
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.bold())
            .foregroundColor(.primary)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.mint)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
