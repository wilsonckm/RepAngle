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
                                     subtitle: "Ensure consistent range of motion. Reps only count if you reach the range you set.") {
                    withAnimation {
                        onboardingIndex = 2
                    }
                }
                                     .tag(1)
                                     .ignoresSafeArea()
                
                //Onboarding page 3
                OnboardingDetailView(bgColor: Color(.black),
                                     headline: "Measurment Accuracy Tip:",
                                     subtitle: "Try to be as consistent as possible with where it is placed pre and post measurement") {
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
