//
//  PaintingWall.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/17.
//

import SwiftUI

struct PaintingWall: View {
    @State private var selectedPainting: Painting?
    let paintings: [Painting]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], alignment: .center, spacing: 10) {
                ForEach(0..<paintings.count) { index in
                    paintingCell(painting: paintings[index])
                        .onTapGesture {
                            selectedPainting = paintings[index]
                        }
                        .padding()
                }
            }
        }
        .sheet(item: $selectedPainting) { item in
            DetailView(painting: item)
        }
    }
    
    func paintingCell(painting: Painting) -> some View {
        Image(painting.image)
            .resizable()
            .scaledToFit()
            .overlay(
                OverlayContent(title: painting.name),
                alignment: .bottom
            )
    }
}

struct OverlayContent: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
            .background(.clear)
            .padding()
    }
}

struct DetailView: View {
    @StateObject var imageProcessor = ImageProcessor.shared
    @State var selection: ProcessEffect = .builtIn
    let painting: Painting
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Stytle: \(selection.rawValue)")
                
                Spacer()
                
                Picker("Select Style", selection: $selection) {
                    ForEach(ProcessEffect.allCases, id: \.self) { value in
                        Text(value.rawValue)
                            .tag(value.rawValue)
                    }
                }
                .onChange(of: selection) { newValue in
                    imageProcessor.process(painting: painting, effect: newValue)
                }
            }
            .padding(.vertical)
            
            ScrollView {
                VStack {
                    Image(painting.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(OverlayContent(title: "Input"), alignment: .bottom)
                
                    Image(uiImage: imageProcessor.output)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(OverlayContent(title: "Output"), alignment: .bottom)
                }
            }
        }
        .padding()
        .onAppear {
            imageProcessor.process(painting: painting, effect: selection)
        }
    }
}

struct PaintingWall_Previews: PreviewProvider {
    static var previews: some View {
        PaintingWall(paintings: Gallery().paintings)
    }
}
