//
//  AudioRecordView.swift
//  RecordVoice
//
//  Created by peak on 2022/3/22.
//

import SwiftUI

struct AudioRecordView: View {
    
    @EnvironmentObject var vm: AudioRecordViewModel
    
    var body: some View {
        if vm.isRecording {
            content
        } else {
            EmptyView()
        }
    }
    
    var content: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack {
                Spacer()
                recordingView
                Spacer()
                actionsView
                releaseView
            }
            .offset(y: 120)
        }
        .gesture(dragGesture)
    }
    
    var recordingView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green)
                .frame(height: 75)
                .frame(width: width)
                .animation(.linear, value: vm.recordTime)
            
            EqualizerIndicatorView()
                .foregroundColor(.primary)
        }
    }
    
    var actionsView: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                cancelView
                Spacer()
                Spacer()
                Spacer()
                translateView
                Spacer()
            }
            Text("Release to send")
        }
    }
    
    var cancelView: some View {
        VStack {
            Text("Release to ancel")
                .foregroundColor(vm.isDragLeading ? .white.opacity(0.7) : .black.opacity(0.7))
                .opacity(vm.isDragLeading ? 1 : 0)
                
            
            Button {
                onCancel()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .padding()
                    .foregroundColor(
                        vm.isDragLeading ? .black.opacity(0.7) : .white.opacity(0.7)
                    )
                    .background(
                        vm.isDragLeading ? Color.white : Color.black.opacity(0.4)
                    )
                    .clipShape(Circle())
                    .scaleEffect(vm.isDragLeading ? 1.2 : 1)
            }
        }
    }
    
    var translateView: some View {
        VStack {
            Text("Convert")
                .foregroundColor(vm.isDragTrailing ? .white.opacity(0.7) : .black.opacity(0.7))
                .opacity(vm.isDragTrailing ? 1 : 0)
            
            Button {
                
            } label: {
                Text("En")
                    .font(.title2)
                    .padding()
                    .foregroundColor(
                        vm.isDragTrailing ? .black.opacity(0.7) : .white.opacity(0.7)
                    )
                    .background(
                        vm.isDragTrailing ? Color.white : Color.black.opacity(0.4)
                    )
                    .clipShape(Circle())
                    .scaleEffect(vm.isDragTrailing ? 1.2 : 1)
            }
        }
    }
    
    var releaseView: some View {
        ZStack {
            Ellipse()
                .stroke(.white.opacity(0.5), lineWidth: 10)
                .frame(width: UIScreen.main.bounds.width + 40, height: 250)
                .background(
                    vm.isDragRelease ? Color.gray : Color.black.opacity(0.3)
                )
                .clipShape(Ellipse())
            
            Image(systemName: "dot.radiowaves.forward")
                .font(.title)
                .offset(y: -40)
        }
    }
    
    var width: CGFloat {
        let totalWidth = UIScreen.main.bounds.width - 150
        let spead = totalWidth / 30
        return 150 + CGFloat(spead) * CGFloat(vm.recordTime)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                vm.updateCurrentLocation(location: value.location)
            }
            .onEnded { _ in
                if vm.isDragLeading {
                    onCancel()
                } else if vm.isDragTrailing {
                    onTranslate()
                } else if vm.isDragRelease {
                    onSend()
                }
            }
    }
    
    func onCancel() {
        vm.delete()
    }
    
    func onSend() {
        vm.stop()
    }
    
    func onTranslate() {
        
    }
}

struct AudioRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordView()
            .environmentObject(AudioRecordViewModel())
    }
}
