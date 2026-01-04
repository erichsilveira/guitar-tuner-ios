import Foundation
import Combine

@MainActor
class TunerViewModel: ObservableObject {
    
    // Published State for UI
    @Published var tuningState: TuningState = .empty
    @Published var selectedStringIndex: Int? = nil
    @Published var currentTuningMode: TuningMode = .standard
    @Published var isListening: Bool = false
    
    // Dependencies
    private let tuningEngine = TuningEngine()
    private let audioKitManager = AudioKitManager()
    
    init() {
        setupAudioPipeline()
    }
    
    private func setupAudioPipeline() {
        audioKitManager.onPitchDetected = { [weak self] pitch, amplitude in
            guard let self = self else { return }
            
            // Filter silence/noise based on amplitude if needed
            // AudioKit PitchTap usually returns 0 if nothing is detected, or erratic values.
            // TuningEngine also has min/max filters.
            
            Task { @MainActor in
                let state = self.tuningEngine.calculateTuningState(detectedFrequency: pitch)
                self.tuningState = state
            }
        }
    }
    
    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    func startListening() {
        audioKitManager.start()
        isListening = true
    }
    
    func stopListening() {
        audioKitManager.stop()
        isListening = false
        tuningState = .empty
    }
    
    func setTargetString(_ index: Int?) {
        selectedStringIndex = index
        if let index = index {
            tuningEngine.setTargetString(index)
        } else {
            tuningEngine.clearTargetString()
        }
    }
    
    func setTuningMode(_ mode: TuningMode) {
        currentTuningMode = mode
        tuningEngine.setTuningMode(mode)
        selectedStringIndex = nil 
        tuningEngine.clearTargetString()
    }
    
    func getTargetNotes() -> [String] {
        return tuningEngine.getTargetNotes()
    }
}
