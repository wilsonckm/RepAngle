//
//  InfoView.swift
//  RepAngle
//
//  Created by Wilson Chan on 6/9/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome to RepAngle")
                        .font(.title)
                    Text("RepAngle is designed to help you track, analyze, and improve your workout form using advanced angle detection and feedback. RepAngle empowers you to get the most out of your training sessions by objectively measuring your movements.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to Use")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Measure range of motion by measuring initial and final positions of a joint.")
                        Text("• Use Recording mode to track a continuous sequence of angles during an exercise.")
                        Text("• Use Target mode to set specific angle goals and receive sensory feedback when you reach the target.")
                        Text("• Count number of repetitions you reached your target.")
                        Text("• Review saved sessions in your history to compare progress over time.")
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Measurement Accuracy")
                        .font(.headline)
                    VStack(alignment:.leading, spacing: 4){
                        Text("For best results, place the device in a consistent position each time you measure. Keep the device aligned with the limb or segment you want to track, and make sure you’re only moving in a single plane — just like you would with a traditional goniometer. Avoid twisting or combining motions, since that can introduce error. Measure flexion/extension, abduction/adduction, or rotation separately for the most accurate results.")
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disclaimers")
                        .font(.headline)
                    Text("RepAngle is intended for educational and self-tracking purposes only. It is not a medical device and should not be used to diagnose, treat, or prevent any medical condition. Measurements may vary depending on device placement, calibration, and user technique. Always consult with a qualified health professional before making changes to your exercise or rehab program.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy")
                        .font(.headline)
                    Text("Your privacy is important. RepAngle processes video and motion data locally on your device and does not collect or share any personal information without your consent.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }
}
#Preview {
    InfoView()
}
