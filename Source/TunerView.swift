import SwiftUI

struct TunerView: View {
    @StateObject private var viewModel = TunerViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header / Mode Selector
                Picker("Tuning Mode", selection: $viewModel.currentTuningMode) {
                    ForEach(TuningMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 10)
                .colorScheme(.dark) // Force picker to dark
                .onChange(of: viewModel.currentTuningMode) { newValue in
                    viewModel.setTuningMode(newValue)
                }
                
                Spacer()
                
                // Note Display
                VStack(spacing: 12) {
                    if viewModel.isListening {
                        Text(viewModel.tuningState.detectedNote.name)
                            .font(.system(size: 100, weight: .black, design: .rounded))
                            .foregroundColor(noteColor)
                            .shadow(color: noteColor.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text(viewModel.tuningState.tuningStatus.rawValue)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.guitarOnBackground)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(noteColor.opacity(0.2))
                                    .overlay(
                                        Capsule().stroke(noteColor.opacity(0.5), lineWidth: 1)
                                    )
                            )
                    } else {
                        VStack(spacing: 15) {
                            Image(systemName: "music.note")
                                .font(.system(size: 60))
                                .foregroundColor(Color.gray.opacity(0.5))
                            Text("Tap Mic to Start")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                Spacer()
                
                // Tuning Bar
                TuningBar(
                    cents: viewModel.tuningState.cents,
                    tuningStatus: viewModel.tuningState.tuningStatus
                )
                .frame(height: 30)
                .padding(.horizontal, 30)
                .opacity(viewModel.isListening ? 1 : 0.3)
                
                Spacer()
                
                // String Selection Buttons
                // Using 2 rows of 3 columns for larger buttons
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    let targetNotes = viewModel.getTargetNotes()
                    ForEach(0..<targetNotes.count, id: \.self) { index in
                        let stringNumber = targetNotes.count - index // 6, 5, 4... for standard order
                        let noteName = targetNotes[index].replacingOccurrences(of: "\\d", with: "", options: .regularExpression)
                        let isSelected = viewModel.selectedStringIndex == index
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                if isSelected {
                                    viewModel.setTargetString(nil)
                                } else {
                                    viewModel.setTargetString(index)
                                }
                            }
                        }) {
                            VStack(spacing: 4) {
                                Text("\(stringNumber)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                
                                Text(noteName)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .opacity(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(
                                ZStack {
                                    if isSelected {
                                        LinearGradient(
                                            gradient: Gradient(colors: [.selectedGradientStart, .selectedGradientEnd]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    } else {
                                        LinearGradient(
                                            gradient: Gradient(colors: [.buttonGradientStart, .buttonGradientEnd]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    }
                                }
                            )
                            .cornerRadius(16)
                            .foregroundColor(isSelected ? .black : .white)
                            .shadow(color: isSelected ? .guitarPrimary.opacity(0.4) : Color.black.opacity(0.3), radius: isSelected ? 8 : 4, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Mic Control Button
                Button(action: {
                    withAnimation {
                        viewModel.toggleListening()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.guitarSurface)
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
                        
                        Image(systemName: viewModel.isListening ? "mic.fill" : "mic.slash.fill")
                            .font(.system(size: 30))
                            .foregroundColor(viewModel.isListening ? .guitarPrimary : .gray)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var noteColor: Color {
        switch viewModel.tuningState.tuningStatus {
        case .inTune: return .guitarPrimary
        case .detectcng: return .gray
        case .tooLow, .tooHigh:
            // Gradient or orange for out of tune could be nice, but sticking to solid for text.
            return .guitarTertiary
        }
    }
}

struct TunerView_Previews: PreviewProvider {
    static var previews: some View {
        TunerView()
    }
}
