//
//  RecordingsList.swift
//  RecordVoice
//
//  Created by peak on 2022/3/21.
//

import SwiftUI

struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordingList, id: \.createdAt) { recording in
                RecordingRow(recording: recording)
                    .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: audioRecorder.delete)
        }
        .listStyle(.plain)
    }
}

struct RecordingRow: View {
    
    var recording: Recording
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            Text("\(recording.fileURL.lastPathComponent)")
            Spacer()
            Image(systemName: "dot.radiowaves.forward")
            
            Text("\(recording.duration)\"")
            Spacer()
            Spacer()
            
            if audioPlayer.isPlaying == false {
                Button {
                    audioPlayer.startPlayback(recording: recording)
                } label: {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                        .foregroundColor(.mint)
                }
            } else {
                Button {
                    audioPlayer.stopPlayback()
                } label: {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }

            }
        }
        .padding()
        .background(.ultraThickMaterial)
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
