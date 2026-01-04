import SwiftUI

struct TuningBar: View {
    let cents: Double
    let tuningStatus: TuningStatus
    
    private let range: Double = 50.0 // +/- 50 cents visible range
    
    var body: some View {
        VStack(spacing: 10) {
            // Text Indicator
            Text("\(Int(cents)) cents")
                .font(.caption)
                .foregroundColor(Color.gray)
            
            // Bar
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // Background Track
                    Rectangle()
                        .fill(Color.guitarSurface)
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    // Center Marker
                    Rectangle()
                        .fill(Color.guitarOnBackground)
                        .frame(width: 2, height: 20)
                    
                    // Tolerance Zone (+/- 5 cents)
                    Rectangle()
                        .fill(Color.guitarPrimary.opacity(0.3))
                        .frame(width: widthForCents(10, totalWidth: geometry.size.width), height: 4)
                    
                    // Indicator Circle
                    Circle()
                        .fill(statusColor)
                        .frame(width: 20, height: 20)
                        .offset(x: offsetForCents(cents, totalWidth: geometry.size.width))
                        .shadow(color: statusColor.opacity(0.5), radius: 5)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: cents)
                }
            }
            .frame(height: 40)
        }
    }
    
    private var statusColor: Color {
        switch tuningStatus {
        case .inTune: return .guitarPrimary
        case .detectcng: return .gray
        case .tooLow, .tooHigh: return .guitarTertiary
        }
    }
    
    private func widthForCents(_ cents: Double, totalWidth: CGFloat) -> CGFloat {
        let fraction = cents / (range * 2)
        return totalWidth * CGFloat(fraction)
    }
    
    private func offsetForCents(_ cents: Double, totalWidth: CGFloat) -> CGFloat {
        // Clamp cents
        let clamped = min(max(cents, -range), range)
        let fraction = clamped / (range * 2)
        return totalWidth * CGFloat(fraction)
    }
}

struct TuningBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            TuningBar(cents: 0, tuningStatus: .inTune)
            TuningBar(cents: -20, tuningStatus: .tooLow)
            TuningBar(cents: 30, tuningStatus: .tooHigh)
        }
        .padding()
    }
}
