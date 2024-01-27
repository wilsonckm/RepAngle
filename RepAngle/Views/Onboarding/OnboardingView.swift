//
//  OnboardingView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment (\.dismiss) var dismiss
    @State var onboardingIndex = 0
    
    var body: some View {
        ZStack {
            if onboardingIndex == 0 {
                Color(Color(red: 111/255, green: 154/255, blue: 189/255))
                    .ignoresSafeArea()
            } else if onboardingIndex == 1 {
                Color(Color(red: 111/255, green: 225/255, blue: 189/255))
                    .ignoresSafeArea()
            } else if onboardingIndex == 2 {
                Color(Color(red: 255/255, green: 154/255, blue: 189/255))
                    .ignoresSafeArea()
            }
            
            
            TabView(selection: $onboardingIndex ) {
                //Onboarding page 1
                OnboardingDetailView(bgColor: Color(red: 111/255, green: 154/255, blue: 189/255),
                                     headline: "",
                                     subtitle: "Track workouts and search for new exercises") {
                    withAnimation {
                        onboardingIndex = 1
                    }
                }
                                     .tag(0)
                                     .ignoresSafeArea()
                
                //Onboarding page 2
                OnboardingDetailView(bgColor: Color(red: 111/255, green: 225/255, blue: 189/255),
                                     headline: "Gain insights on your progress",
                                     subtitle: "Learn about how to exercise effectively") {
                    withAnimation {
                        onboardingIndex = 2
                    }
                }
                                     .tag(1)
                                     .ignoresSafeArea()
                
                //Onboarding page 3
                OnboardingDetailView(bgColor: Color(red: 255/255, green: 154/255, blue: 189/255),
                                     headline: "Chat with a personal coach",
                                     subtitle: "Get personalized care for your specific goals") {
                    dismiss()
                }
                                     .tag(2)
                                     .ignoresSafeArea()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            //Shows index of onboarding
            VStack {
                Spacer()
                HStack (spacing: 16) {
                    Spacer()
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(onboardingIndex == 0 ? .white : .gray)
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(onboardingIndex == 1 ? .white : .gray)
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(onboardingIndex == 2 ? .white : .gray)
                    Spacer()
                }
                .padding(.bottom, 200)
            }
        }
        .ignoresSafeArea()
            
    }
}

#Preview {
    OnboardingView()
}
