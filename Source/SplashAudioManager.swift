import Foundation
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFoundation

class SplashAudioManager: ObservableObject {
    private let engine = AudioEngine()
    private var strings: [PluckedString] = []
    private var mixer = Mixer()
    
    // E Major Chord Frequencies (E2, B2, E3, G#3, B3, E4)
    private let frequencies: [Double] = [82.41, 123.47, 164.81, 207.65, 246.94, 329.63]
    
    init() {
        // Create 6 plucked strings
        for frequency in frequencies {
            let pluck = PluckedString()
            pluck.frequency = AUValue(frequency)
            pluck.amplitude = 0.5
            strings.append(pluck)
            mixer.addInput(pluck)
        }
        
        engine.output = mixer
    }
    
    func playStrum() {
        Task {
            do {
                try engine.start()
                
                // Simulate a strum by triggering strings with slight delay
                // Downstroke: Low E -> High E
                for (index, string) in strings.enumerated() {
                    let delay = Double(index) * 0.05 // 50ms delay between strings
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    
                    // Trigger the pluck
                    string.trigger(frequency: AUValue(frequencies[index]), amplitude: 0.5)
                }
                
                // Stop engine after 3 seconds to save resources
                try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                engine.stop()
                
            } catch {
                print("Splash Audio Error: \(error)")
            }
        }
    }
}
