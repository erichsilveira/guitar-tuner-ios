import Foundation

enum TuningStatus: String, CaseIterable {
    case detectcng = "DETECTING" // Will map to "Listening..." or similar
    case tooLow = "TOO_LOW"
    case tooHigh = "TOO_HIGH"
    case inTune = "IN_TUNE"
}

struct Note: Equatable {
    let name: String
    let octave: Int
    let frequency: Double
    
    static func fromFrequency(_ frequency: Double) -> Note {
        if frequency <= 0 {
            return Note(name: "-", octave: 0, frequency: 0)
        }
        
        // midiNote = 12 × log₂(f/440) + 69
        let midiNote = Int(round(12 * log2(frequency / 440.0) + 69))
        
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let nameIndex = midiNote % 12
        let name = noteNames[nameIndex >= 0 ? nameIndex : nameIndex + 12]
        let octave = (midiNote / 12) - 1
        
        return Note(name: name, octave: octave, frequency: frequency)
    }
}

enum TuningMode: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case dropD = "Drop D"
    // Add more as needed, keeping it simple for now matching "Standard" from code usually
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var frequencies: [Double] {
        switch self {
        case .standard:
            return [82.41, 110.00, 146.83, 196.00, 246.94, 329.63] // E2, A2, D3, G3, B3, E4
        case .dropD:
            return [73.42, 110.00, 146.83, 196.00, 246.94, 329.63] // D2, A2, D3, G3, B3, E4
        }
    }
    
    var noteNames: [String] {
        switch self {
        case .standard:
            return ["E2", "A2", "D3", "G3", "B3", "E4"]
        case .dropD:
            return ["D2", "A2", "D3", "G3", "B3", "E4"]
        }
    }
}

struct TuningState: Equatable {
    let detectedNote: Note
    let targetFrequency: Double
    let cents: Double
    let tuningStatus: TuningStatus
    
    // Default state
    static let empty = TuningState(
        detectedNote: Note(name: "-", octave: 0, frequency: 0),
        targetFrequency: 0.0,
        cents: 0.0,
        tuningStatus: .detectcng
    )
}
