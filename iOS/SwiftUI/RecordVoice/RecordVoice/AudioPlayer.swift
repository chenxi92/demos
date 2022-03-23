//
//  AudioPlayer.swift
//  RecordVoice
//
//  Created by peak on 2022/3/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback(recording: Recording) {
        print("begin play: \(recording)")
        if FileManager.default.fileExists(atPath: recording.fileURL.path) == false {
            print("file not exist: \(recording.fileURL.path)")
        }
        
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("playing over the device's speakers failed: \(error.localizedDescription)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("playback failed: \(error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
}

// MARK: AVAudioPlayerDelegate

extension AudioPlayer {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            print("did finished playing")
        }
    }
}
