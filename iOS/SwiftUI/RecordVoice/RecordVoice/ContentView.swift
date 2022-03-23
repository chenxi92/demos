//
//  ContentView.swift
//  RecordVoice
//
//  Created by peak on 2022/3/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = AudioRecordViewModel()
    
    var body: some View {
        VStack {
            RecordingsList(audioRecorder: vm.audioRecorder)
            
            if !vm.isRecording {
                startButton
            }
        }
        .overlay {
            AudioRecordView()
        }
        .environmentObject(vm)
    }
    
    var startButton: some View {
        Text(vm.isRecording ? "Release to send": "Hold to Talk")
            .foregroundColor(.primary)
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
            .onTapGesture {
                vm.start()
            }
    }
    
    var stopButton: some View {
        Button {
        } label: {
            Image(systemName: "stop.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .foregroundColor(.blue)
                .padding(.bottom, 40)
                .overlay {
                    Text("Stop")
                        .foregroundColor(.primary)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
