// Views/OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    // Binding to control the visibility state in RootView
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background: Subtle Gradient to match app theme
            LinearGradient(
                colors: [Color.white, Color.pink.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // MARK: - Swipeable Content
                TabView(selection: $currentPage) {
                    // Screen 1: Virtual Manicure
                    OnboardingPage(
                        imageName: "hand.raised.fill",
                        title: "Virtual Manicure",
                        description: "Snap a photo of your hand and instantly try on hundreds of stunning nail designs.",
                        iconColor: .pink
                    )
                    .tag(0)
                    
                    // Screen 2: AI Realism
                    OnboardingPage(
                        imageName: "sparkles.rectangle.stack.fill",
                        title: "AI-Powered Realism",
                        description: "Our advanced Gemini AI adapts every polish to your unique hand shape and lighting.",
                        iconColor: .purple
                    )
                    .tag(1)
                    
                    // Screen 3: Premium & Benefits
                    OnboardingPage(
                        imageName: "crown.fill",
                        title: "Go Limitless",
                        description: "Unlock exclusive premium styles, save your favorites, and enjoy unlimited generations.",
                        iconColor: .yellow
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                // MARK: - Navigation Controls
                HStack {
                    // Skip Button (Hidden on the last page)
                    if currentPage < 2 {
                        Button(action: completeOnboarding) {
                            Text("Skip")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(.leading, 30)
                    } else {
                        // Spacer to maintain layout balance
                        Spacer().frame(width: 60)
                    }
                    
                    Spacer()
                    
                    // Next / Get Started Button
                    if currentPage < 2 {
                        Button(action: {
                            withAnimation { currentPage += 1 }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "arrow.right")
                            }
                            .font(.headline)
                            .foregroundColor(.pink)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                        }
                        .padding(.trailing, 20)
                    } else {
                        Button(action: completeOnboarding) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 40)
                                .background(Color.pink)
                                .clipShape(Capsule())
                                .shadow(color: .pink.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
}

// MARK: - Reusable Page Component
struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated Icon Container
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 220, height: 220)
                
                Circle()
                    .stroke(iconColor.opacity(0.3), lineWidth: 2)
                    .frame(width: 250, height: 250)
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(iconColor)
                    .shadow(color: iconColor.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            // Text Content
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
                    .lineSpacing(6) // Improved readability
            }
            
            Spacer()
            Spacer()
        }
    }
}
