import Foundation
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFoundation

class AudioKitManager: ObservableObject {
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode?
    var silencer: Fader?
    var tracker: PitchTap?
    
    var onPitchDetected: ((Double, Double) -> Void)?
    
    init() {
        setupAudioKit()
    }
    
    private func setupAudioKit() {
        guard let input = engine.input else {
            print("No audio input available")
            return
        }
        
        mic = input
        
        // Silence the output so we don't hear feedback
        silencer = Fader(mic!)
        silencer?.gain = 0
        engine.output = silencer
        
        // Setup PitchTap (Tracker)
        tracker = PitchTap(mic!) { [weak self] pitch, amp in
            // Dispatch to main thread just in case, or handle in ViewModel
            // AudioKit callback is on a background queue usually.
            // Debug Log:
            if amp[0] > 0.1 { print("🎤 Input: Freq=\(pitch[0]), Amp=\(amp[0])") }
            self?.onPitchDetected?(Double(pitch[0]), Double(amp[0]))
        }
    }
    
    func start() {
        // Request Permission first
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.startEngine()
            } else {
                print("Permission denied")
            }
        }
    }
    
    private func startEngine() {
        do {
            // Configure Session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .mixWithOthers])
            try session.setActive(true)
            
            try engine.start()
            tracker?.start()
        } catch {
            print("AudioKit Error: \(error)")
        }
    }
    
    func stop() {
        engine.stop()
        tracker?.stop()
    }
}
