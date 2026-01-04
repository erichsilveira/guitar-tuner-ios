import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0
    
    @StateObject private var audioManager = SplashAudioManager()
    
    var body: some View {
        ZStack {
            // Match the gradient from TunerView
            LinearGradient(
                gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("Logo") // Uses the Logo.imageset we just created
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotation))
                    .shadow(color: .guitarPrimary.opacity(0.6), radius: isAnimating ? 20 : 0, x: 0, y: 0)
                
                Spacer()
            }
        }
        .onAppear {
            // Play Sound
            audioManager.playStrum()
            
            // Entrance
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // "Strum" effect - vibrate/wiggle shortly after appearing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimating = true
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 5)) {
                    rotation = 5.0
                }
                
                // Return to center
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 5)) {
                        rotation = -3.0
                    }
                }
                
                // Settle
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        rotation = 0.0
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
