import SwiftUI

@main
struct GuitarTunerApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TunerView()
                
                if showSplash {
                    SplashScreenView()
                        .transition(AnyTransition.opacity)
                        .onAppear {
                            // Dismiss splash after 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
        }
    }
}
