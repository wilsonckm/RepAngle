//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI
import CoreMotion
import AudioToolbox

struct MeasureView: View {
    
    private var motionManager = MotionManager.shared
    // Measure
    @State private var initialQuaternion: CMQuaternion?
    @State private var rotationAngle: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var isMeasuring: Bool = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isMeasuring
        }
    }
    // Target
    @State private var currentQuaternion: CMQuaternion?
    @State private var targetQuaternion: CMQuaternion?
    @State private var isTargetSet: Bool = false
    @State private var repCount: Double = 0.0
    @State private var rangeAccuracy = 10.0
    @State private var repAlreadyCounted = false
    
    // Record
    @State private var isRecording: Bool = false
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
                        resetTarget()
                    }
                }
                HStack {
                    Button(action: {
                        // To do: Record
                        isRecording.toggle()
                    }) {
                        Image(systemName: "record.circle")
                            .foregroundStyle(isRecording ? .red : .gray)
                            .font(.system(size: 24))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()
                    
                    Button(action: {
                        if !isTargetSet {
                            setTarget()
                        } else {
                            resetTarget()
                        }
                    }) {
                        Image(systemName: "scope")
                            .foregroundStyle(isTargetSet ? (didReachTarget() ? .green : .red) : .gray)
                            .font(.system(size: 24))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .disabled(!isMeasuring)
                    .opacity(isMeasuring ? 1 : 0.5)
                }
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 50)
                    .foregroundStyle(didReachTarget() ? .green : .gray)
                
                
                Text("\(targetQuaternion)")
                Text("\(repCount)")
                Text("is Target Set? \(isTargetSet)")
                if didReachTarget() == true {
                    Text("Target Reached")
                } else {
                    Text("Target not reached")
                }
                VStack {
                    Slider(
                        value: $rangeAccuracy,
                        in: 2...15
                    )
                    Text("Target Accuracy: ±\(rangeAccuracy, specifier: "%.1f")°")
                }
                .padding()
                
                VStack {
                    Button(isTargetSet ? "Reset" : "Set Target") {
                        if !isTargetSet {
                            setTarget()
                        } else {
                            resetTarget()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .tint(.blue)
                }
            }
        }
        .padding()
        .onDisappear {
            // Always clean up timer if the view disappears
            timer?.invalidate()
            // Turns off screen
            UIApplication.shared.isIdleTimerDisabled = false
            stopMeasuring()
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
    
    // Measure
//    private func startMeasuring() {
//        rotationAngle = 0.0
//        isMeasuring = true
//        motionManager.startUpdates()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
//            initialQuaternion = motionManager.currentQuaternion
//            currentQuaternion = motionManager.currentQuaternion
//            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
//                updateRotation()
//            }
//        }
//    }
  
    private func startMeasuring() {
        rotationAngle = 0.0
        isMeasuring = true
        motionManager.startUpdates()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            initialQuaternion = motionManager.currentQuaternion
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                guard let start = initialQuaternion else { return }
                currentQuaternion = motionManager.currentQuaternion

                if let current = currentQuaternion {
                    let newAngle = calculateRotationAngle(from: start, to: current)
                    rotationAngle = newAngle
                }

                if isTargetSet {
                    _ = didReachTarget()
                }
            }
        }
    }
    
    private func stopMeasuring() {
        timer?.invalidate()
        timer = nil
        isMeasuring = false
        motionManager.stopUpdates()
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
    
    
    // Target
    
    private func startUpdates() {
        motionManager.startUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            currentQuaternion = motionManager.currentQuaternion
            if isMeasuring && isTargetSet {
                _ = didReachTarget() // This will handle the vibrate and rep count
            }
        }
    }
    
    private func stopUpdates() {
        timer?.invalidate()
        timer = nil
        motionManager.stopUpdates()
    }
    
    private func setTarget() {
        targetQuaternion = currentQuaternion
        isTargetSet = true
    }
    
    private func resetTarget() {
        targetQuaternion = nil
        isTargetSet = false
        repCount = 0
        isMeasuring = false
    }
    
    private func didReachTarget() -> Bool {
        guard let target = targetQuaternion, let current = currentQuaternion else {
            return false
        }
        
        let angleDifference = calculateRotationAngle(from: target, to: current)
        
        if angleDifference <= rangeAccuracy {
            if !repAlreadyCounted {
                vibrate()
                addRep()
                repAlreadyCounted = true  // ✅ Mark that we counted this rep
            }
            return true
        } else {
            repAlreadyCounted = false // ✅ Reset when they leave the target zone
            return false
        }
    }
    
    private func addRep() {
        repCount += 1
    }
    
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

#Preview {
    MeasureView()
}
