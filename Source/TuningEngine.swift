import Foundation

class TuningEngine {
    private var currentTuningMode: TuningMode = .standard
    private var targetStringIndex: Int? = nil
    
    private let inTuneThreshold: Double = 5.0 // cents
    private let minFrequency: Double = 60.0   // Hz
    private let maxFrequency: Double = 500.0  // Hz
    
    func setTuningMode(_ mode: TuningMode) {
        self.currentTuningMode = mode
    }
    
    func setTargetString(_ index: Int) {
        self.targetStringIndex = index
    }
    
    func clearTargetString() {
        self.targetStringIndex = nil
    }
    
    func calculateTuningState(detectedFrequency: Double) -> TuningState {
        // Check if frequency is in valid range
        if detectedFrequency < minFrequency || detectedFrequency > maxFrequency {
            return TuningState(
                detectedNote: Note(name: "-", octave: 0, frequency: 0),
                targetFrequency: 0.0,
                cents: 0.0,
                tuningStatus: .detectcng
            )
        }
        
        // Get detected note
        let detectedNote = Note.fromFrequency(detectedFrequency)
        
        // Find closest target
        let targetFrequency = findClosestTargetFrequency(detectedFrequency)
        
        // Calculate cents
        let cents = calculateCents(detectedFrequency: detectedFrequency, targetFrequency: targetFrequency)
        
        // Determine Status
        let status: TuningStatus
        if abs(cents) <= inTuneThreshold {
            status = .inTune
        } else if cents < 0 {
            status = .tooLow
        } else {
            status = .tooHigh
        }
        
        return TuningState(
            detectedNote: detectedNote,
            targetFrequency: targetFrequency,
            cents: cents,
            tuningStatus: status
        )
    }
    
    private func calculateCents(detectedFrequency: Double, targetFrequency: Double) -> Double {
        if targetFrequency <= 0 || detectedFrequency <= 0 { return 0.0 }
        return 1200.0 * log2(detectedFrequency / targetFrequency)
    }
    
    private func findClosestTargetFrequency(_ detectedFrequency: Double) -> Double {
        let frequencies = currentTuningMode.frequencies
        
        // Target specific string if selected
        if let index = targetStringIndex, frequencies.indices.contains(index) {
            return frequencies[index]
        }
        
        // Find closest from all strings
        var closestFreq = frequencies[0]
        var minDiff = abs(detectedFrequency - closestFreq)
        
        for freq in frequencies {
            let diff = abs(detectedFrequency - freq)
            if diff < minDiff {
                minDiff = diff
                closestFreq = freq
            }
        }
        
        return closestFreq
    }
    
    func getTargetNotes() -> [String] {
        return currentTuningMode.noteNames
    }
}
