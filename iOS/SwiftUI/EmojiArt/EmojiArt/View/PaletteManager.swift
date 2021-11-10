//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by 陈希 on 2021/11/7.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
    @Environment(\.presentationMode) var presentationMode
    
    // we injdect a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palatte in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palatte])) {
                        VStack(alignment: .leading) {
                            Text(palatte.name)
                            Text(palatte.emojis)
                        }
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in the indexSet from its array
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in the indexSet to a newOffset in its array
                .onMove { indexSet, newOffSet in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffSet)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable { presentationMode.wrappedValue.dismiss() }
            // add an EditButton on the trailing side of our NavigationView
            // and a Close button on the leading side
            // notice we are adding this .toolbar to the list
            // (not to the NavigationView)
            // (NavigationView looks at the View it is currently showing for toolbar info)
            // (ditto title and titleddisplaymode above)
            .toolbar {
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 8")
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
