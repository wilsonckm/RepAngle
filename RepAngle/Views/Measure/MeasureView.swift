//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI
import CoreMotion

struct MeasureView: View {
    
    private var motionManager = MotionManager.shared
    @State private var initialQuaternion: CMQuaternion?
    @State private var currentQuaternion: CMQuaternion?
    @State private var rotationAngle: Double = 0.0
    @State private var timer: Timer? = nil
    
    @State private var isMeasuring: Bool = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isMeasuring
        }
    }
    
    @State private var showingHistory = false
    @State private var showingInfo = false
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                let midX = geometry.size.width / 2
                let midY = geometry.size.height / 2

                // Horizontal line
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                    .position(x: midX, y: midY)

                // Vertical line
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 1)
                    .position(x: midX, y: midY)
            }
            VStack {
                HStack {
                    Button(action: {
                        showingHistory = true
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    Spacer()
                    Button(action: {
                        showingInfo = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.primary)
                        
                            .font(.system(size: 24))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                Spacer()
                //Measure
                ZStack {
                    
                    Circle()
                        .opacity(0.01)
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(isMeasuring ? .red : .green)
                    VStack (alignment: .center){
                        Text("\(rotationAngle, specifier: "%.0f")°")
                            .font(.system(size: 72))
                            .bold()
                            .padding(.vertical, -10)
                        Divider()
                            .padding(.horizontal,20)
                        Text("\(180 - rotationAngle, specifier: "%.0f" )°")
                            .font(.system(size: 64))
                            .padding(.vertical, -10)
                    }
                }
                .onTapGesture {
                    motionManager.startUpdates()
                    if !isMeasuring {
                        startMeasuring()
                    } else {
                        stopMeasuring()
                    }
                }
                // To do: Target functionality
                HStack {
                    Spacer()
                    Button(action: {
                        // To do
                    }) {
                        Image(systemName: "scope")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
        }
        .padding()
        .onDisappear {
            // Always clean up timer if the view disappears
            timer?.invalidate()
            // Turns off screen
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .sheet(isPresented: $showingHistory) {
                   Text("History")
                       .presentationDetents([.medium, .large])
               }
        .sheet(isPresented: $showingInfo) {
                   Text("Info")
                .presentationDetents([.large])
               }
    }

    private func startMeasuring() {
        rotationAngle = 0.0
        isMeasuring = true
        motionManager.startUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
            initialQuaternion = motionManager.currentQuaternion
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                updateRotation()
            }
        }
    }
    
    private func stopMeasuring() {
        timer?.invalidate()
        timer = nil
        isMeasuring = false
    }
    
    private func updateRotation() {
        guard let start = initialQuaternion, let current = motionManager.currentQuaternion else { return }
        let newAngle = calculateRotationAngle(from: start, to: current)

            rotationAngle = newAngle
    }
    
    private func calculateRotationAngle(from start: CMQuaternion, to end: CMQuaternion) -> Double {
        let dot = start.x * end.x + start.y * end.y + start.z * end.z + start.w * end.w
        let clampedDot = min(1.0, max(-1.0, dot)) // Clamp to prevent NaN
        let angleRadians = 2 * acos(clampedDot)
        var angleDegrees = angleRadians * 180 / .pi
        
        // Always take the smaller angle
        if angleDegrees > 180 {
            angleDegrees = 360 - angleDegrees
        }
        
        return angleDegrees
    }
}

#Preview {
    MeasureView()
}
