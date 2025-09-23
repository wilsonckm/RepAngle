//
//  RepAngleApp.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI
import SwiftData

@main
struct RepAngleApp: App {
    
    @AppStorage("Onboarding") var needsOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .fullScreenCover(isPresented: $needsOnboarding) {
                    needsOnboarding = false
                } content: {
                    OnboardingView()
                }
        }
        .modelContainer(for: MeasurementItem.self)
    }
}
