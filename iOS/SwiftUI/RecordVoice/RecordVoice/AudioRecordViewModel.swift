//
//  AudioRecordViewModel.swift
//  RecordVoice
//
//  Created by peak on 2022/3/22.
//

import Foundation
import SwiftUI

class AudioRecordViewModel: ObservableObject {
    @Published var recordTime: Int = 0
    private var timer: Timer?
    
    @Published var isRecording: Bool = false
    
    @Published var isDragLeading: Bool = false
    @Published var isDragTrailing: Bool = false
    @Published var isDragRelease: Bool = true
    
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    func start() {
        isRecording = true
        
        audioRecorder.startRecording()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.recordTime += 1
        }
    }
    
    func stop() {
        isRecording = false
        
        audioRecorder.stopRecording()
        
        reset()
    }
    
    func delete() {
        isRecording = false
        
        audioRecorder.deleteRecording()
        
        reset()
    }
    
    private func reset() {
        timer?.invalidate()
        recordTime = 0
        
        isDragRelease = true
        isDragLeading = false
        isDragTrailing = false
    }
    
    func updateCurrentLocation(location: CGPoint) {
        
        let height = UIScreen.main.bounds.size.height
        if height - location.y < 250 {
            isDragRelease = true
            isDragLeading = false
            isDragTrailing = false
            return
        }
        
        isDragRelease = false
        let width = UIScreen.main.bounds.size.width * 0.5
        isDragLeading = location.x < width
        isDragTrailing = location.x > width
    }
    
}
