// Views/OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    // Renamed for clarity: logic was inverted previously
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPage(image: "hand.draw", title: "Virtual Try-On", description: "Try nail art before applying — virtually using AI.")
                        .tag(0)
                    
                    OnboardingPage(image: "wand.and.stars", title: "Realistic AI", description: "Advanced AI generates previews on your own hand.")
                        .tag(1)
                    
                    OnboardingPage(image: "heart.fill", title: "Save Favorites", description: "Collect your favorite styles and unlock unlimited designs.")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                HStack {
                    if currentPage < 2 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button("Next") {
                            withAnimation { currentPage += 1 }
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    } else {
                        Button(action: completeOnboarding) {
                            Text("Get Started")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func completeOnboarding() {
        // Set to TRUE to indicate we have seen it
        withAnimation {
            isOnboardingCompleted = true
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(.pink)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
