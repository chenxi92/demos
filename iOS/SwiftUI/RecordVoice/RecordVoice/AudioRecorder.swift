//
//  AudioRecorder.swift
//  RecordVoice
//
//  Created by peak on 2022/3/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

/// https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

class AudioRecorder: NSObject, ObservableObject {

    override init() {
        super.init()
        getRecordingData()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordingList: [Recording] = [] {
        didSet {
            saveRecordingData()
        }
    }
    
    var isRecording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording(name: String? = nil) {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to setup recoding session: \(error)")
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let url = audioFileURL(name: name)
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    func deleteRecording() {
        guard audioRecorder.isRecording else {
            return
        }
        
        let success = audioRecorder.deleteRecording()
        print("delete recording: \(success)")
    }
    
    func stopRecording() {
        guard audioRecorder.isRecording else {
            return
        }
        
        let duration = (Int)(audioRecorder.currentTime)
        let url = audioRecorder.url
        print("stop recording: \(duration)")
        
        audioRecorder.stop()
        isRecording = false
        
        var recording = Recording(fileURL: url)
        recording.duration = duration
        recording.createdAt = getCreationDate(for: url)
        
        recordingList.insert(recording, at: 0)
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let recording = recordingList.remove(at: index)
            do {
                try FileManager.default.removeItem(at: recording.fileURL)
            } catch {
                print("Fail could not be deleted: \(error.localizedDescription)")
            }
        }
    }
}

extension AudioRecorder {
    
    func saveRecordingData() {
        do {
            let data = try JSONEncoder().encode(self.recordingList)
            try data.write(to: recordingDataPath())
        } catch {
            print("Error save recording data: \(error.localizedDescription)")
        }
        
        print("\n\nafter save data: \n\(recordingList)")
    }
    
    func getRecordingData() {
        let url = recordingDataPath()
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let list = try JSONDecoder()
                .decode([Recording].self, from: data)
            fetchRecordings(list)
        } catch {
            print("Error get recording data: \(error.localizedDescription)")
        }
        
        print("\n\nafter get data: \n\(recordingList)")
    }
    
    func fetchRecordings(_ list: [Recording]) {
        var temp: [Recording] = []
        for audioFile in allAudioFiles() {
            if var item = list.first(where: { $0.fileURL.lastPathComponent == audioFile.lastPathComponent }) {
                item.fileURL = audioFile
                item.createdAt = getCreationDate(for: audioFile)
                temp.append(item)
            }
        }
        temp.sort(by: { $0.createdAt > $1.createdAt})
        
        self.recordingList = temp

        objectWillChange.send(self)
    }
}

extension AudioRecorder {
        
    func audioFileURL(name: String? = nil) -> URL {
        let directory = audioFileDirectory()
        let filename =  (name ?? "") + Date().toString(dateFormat: "dd-MM-YY_'at'_HH-mm-ss") + ".m4a"
        return directory.appendingPathComponent(filename)
    }
    
    func allAudioFiles() -> [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: audioFileDirectory(), includingPropertiesForKeys: nil)
        } catch {
            print("Error get all audio files: \(error.localizedDescription)")
            return []
        }
    }
    
    func audioFileDirectory() -> URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioDirectory = documentDirectory.appendingPathComponent("audio", isDirectory: true)
        if fileManager.fileExists(atPath: audioDirectory.absoluteString) == false {
            try? fileManager.createDirectory(at: audioDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        return audioDirectory
    }
    
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any], let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func recordingDataPath() -> URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("recordingList")
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateformater = DateFormatter()
        dateformater.dateFormat = format
        return dateformater.string(from: self)
    }
}
