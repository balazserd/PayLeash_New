//
//  NewTransactionView+Model.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 24..
//

import Foundation
import Combine
import Speech

extension NewTransactionView {
    class ViewModel: NSObject, ObservableObject {
        @Published var shortDescription: String = ""
        private var shortDescriptionBeforeVoiceRecognitionBegan: String = ""
        var amount: Double = 0.0
        var date: Date = Date()
        var category: TransactionCategory? = nil
        
        @Published var shouldRecordUserVoice: Bool = false
        @Published var speechRecognitionIsAvailable: Bool
        @Published var speechRecognitionPermissionMessage: String? = nil
        @Published var speechRecognitionProcessingMessage: String? = nil
        private var speechRecognizer = SFSpeechRecognizer()
        private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest? = nil
        
        private let audioEngine = AVAudioEngine()
        
        private var cancellableSet = Set<AnyCancellable>()
        
        override init() {
            speechRecognizer?.queue = OperationQueue() //Needs to be a different queue since it blocks main queue otherwise.
            speechRecognizer?.queue.qualityOfService = .userInteractive
            speechRecognitionIsAvailable = speechRecognizer?.isAvailable ?? false
            
            super.init()
            
            speechRecognizer?.delegate = self
            
            setupSubscriptions()
        }
        
        func dismissErrors() {
            self.speechRecognitionPermissionMessage = nil
            self.speechRecognitionPermissionMessage = nil
        }
        
        private func setupSubscriptions() {
            //Recording became unavailable, immediately stop recording
            $speechRecognitionIsAvailable
                .filter { !$0 }
                .sink { [weak self] _ in self?.shouldRecordUserVoice = false }
                .store(in: &cancellableSet)
            
            //User wants to begin voice recording
            $shouldRecordUserVoice
                .sink { [weak self] shouldBegin in
                    guard
                        let self = self,
                        self.speechRecognizer != nil,
                        self.speechRecognizer!.isAvailable
                    else { return }
                    
                    if shouldBegin {
                        do {
                            try self.voiceRecordingShouldBegin()
                        } catch {
                            self.speechRecognitionPermissionMessage = "Failed to begin capturing voice."
                        }
                    } else {
                        self.voiceRecordingShouldEnd()
                    }
                }
                .store(in: &cancellableSet)
        }
        
        private func voiceRecordingShouldBegin() throws {
            switch SFSpeechRecognizer.authorizationStatus() {
                case .restricted, .denied:
                    self.speechRecognitionPermissionMessage = "You explicitly denied speech recognition permission. You need to enable it in settings before using it."
                    
                case .notDetermined:
                    SFSpeechRecognizer.requestAuthorization { _ in
                        try! self.voiceRecordingShouldBegin()
                    }
                    
                case .authorized:
                    self.speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    self.speechRecognitionRequest!.shouldReportPartialResults = true
                    
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                    
                    let inputNode = audioEngine.inputNode
                    let recordingFormat = inputNode.outputFormat(forBus: 0)
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                        self?.speechRecognitionRequest!.append(buffer)
                    }
                    
                    audioEngine.prepare()
                    try audioEngine.start()
                    
                    shortDescriptionBeforeVoiceRecognitionBegan = shortDescription
                    
                    self.speechRecognizer?.recognitionTask(with: self.speechRecognitionRequest!) { [weak self] result, error in
                        if let result = result {
                            print(result.bestTranscription.formattedString)
                            
                            if let self = self {
                                DispatchQueue.main.async {
                                    self.shortDescription = self.shortDescriptionBeforeVoiceRecognitionBegan + result.bestTranscription.formattedString
                                }
                            }
                        }
                        
                        if error != nil || (result?.isFinal ?? false) {
                            if error != nil {
                                DispatchQueue.main.async {
                                    self?.speechRecognitionProcessingMessage = "An error occured while capturing voice: \(error.debugDescription)"
                                }
                            }
                            
                            self?.audioEngine.stop()
                            inputNode.removeTap(onBus: 0)
                        }
                    }
                    
                @unknown default:
                    fatalError()
            }
        }
        
        private func voiceRecordingShouldEnd() {
            self.speechRecognitionRequest?.endAudio()
        }
    }
}

extension NewTransactionView.ViewModel: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        speechRecognitionIsAvailable = available
    }
}
