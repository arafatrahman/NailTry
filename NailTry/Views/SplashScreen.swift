// Views/SplashScreen.swift
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var phase = 0.0
    
    var body: some View {
        if isActive {
            // Handled by RootView switching
            EmptyView()
        } else {
            ZStack {
                // Background
                LinearGradient(colors: [.white, Color.pink.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                // Animated Waves at the bottom
                ZStack(alignment: .bottom) {
                    Wave(strength: 20, frequency: 15, phase: phase)
                        .fill(Color.pink.opacity(0.3))
                        .frame(height: 200)
                        .offset(y: 10)
                    
                    Wave(strength: 25, frequency: 12, phase: phase + 10)
                        .fill(Color.purple.opacity(0.3))
                        .frame(height: 200)
                        .offset(y: 20)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                
                // Logo Content
                VStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(isActive ? 0.8 : 1.0)
                        .opacity(isActive ? 0 : 1)
                    
                    Text("NailTry")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
            }
            .onAppear {
                // 1. Wave Animation
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
                
                // 2. Transition Logic
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Wave Shape

struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double
    
    // Allow the phase to be animated
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midHeight = height / 2
        
        // Calculate wavelength based on width and frequency
        let wavelength = width / (frequency / 10.0) // Scaling factor for smoother look
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let sine = sin(2 * .pi * relativeX + phase)
            let y = midHeight + (strength * sine)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Close the shape to fill the bottom area
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}
