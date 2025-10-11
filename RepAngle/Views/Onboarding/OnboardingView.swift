//
//  OnboardingView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @State var onboardingIndex = 0
    
    var body: some View {
        ZStack {
            if onboardingIndex == 0 {
                Color(.black)
                    .ignoresSafeArea()
            } else if onboardingIndex == 1 {
                Color(.black)
                    .ignoresSafeArea()
            } else if onboardingIndex == 2 {
                Color(.black)
                    .ignoresSafeArea()
            }
            
            
            TabView(selection: $onboardingIndex ) {
                //Onboarding page 1
                OnboardingDetailView(bgColor: Color(.black),
                                     headline: "Welcome to Rep Angle",
                                     subtitle: "Digital Goniometer to help you measure joint range of motion!") {
                    withAnimation {
                        onboardingIndex = 1
                    }
                }
                                     .tag(0)
                                     .ignoresSafeArea()
                
                //Onboarding page 2
                OnboardingDetailView(bgColor: Color(.black),
                                     headline: "Track your reps",
                                     subtitle: "Ensure consistent range of motion. Reps only count if you reach the target you set.") {
                    withAnimation {
                        onboardingIndex = 2
                    }
                }
                                     .tag(1)
                                     .ignoresSafeArea()
                
                //Onboarding page 3
                OnboardingDetailView(bgColor: Color(.black),
                                     headline: "Measurment Accuracy Tip:",
                                     subtitle: "For best results, place the device in a consistent position each time you measure. Keep the device aligned with the limb or segment you want to track, and make sure you’re only moving in a single plane — just like you would with a traditional goniometer. Avoid twisting or combining motions, since that can introduce error. Measure flexion/extension, abduction/adduction, or rotation separately for the most accurate results.") {
                    withAnimation {
                        onboardingIndex = 3
                    }
                }
                                     .tag(2)
                                     .ignoresSafeArea()
                
                //Onboarding page 4
                OnboardingDetailView(bgColor: Color(.black),
                                     headline: "Disclaimer and Safe Use",
                                     subtitle: "RepAngle is not a medical device. Always consult a professional for clinical decisions.") {
                    dismiss()
                }
                                     .tag(3)
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
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(onboardingIndex == 3 ? .white : .gray)
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
