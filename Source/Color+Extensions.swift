import SwiftUI

extension Color {
    // Android Theme Colors
    static let guitarPrimary = Color(hex: "00FF41") // Neon Green
    static let guitarSecondary = Color(hex: "FFD700") // Gold
    static let guitarTertiary = Color(hex: "FFFF31") // Yellow/Reddish
    static let guitarBackground = Color(hex: "1A1A1A") // Dark Grey
    static let guitarSurface = Color(hex: "2A2A2A") // Surface Grey
    
    static let guitarOnPrimary = Color.black
    static let guitarOnBackground = Color.white
    
    // New Gradients & Accents
    static let backgroundGradientStart = Color(hex: "121212")
    static let backgroundGradientEnd = Color(hex: "1E1E1E")
    
    static let buttonGradientStart = Color(hex: "2C2C2C")
    static let buttonGradientEnd = Color(hex: "3D3D3D")
    
    static let selectedGradientStart = Color(hex: "00FF41")
    static let selectedGradientEnd = Color(hex: "00CC33")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
