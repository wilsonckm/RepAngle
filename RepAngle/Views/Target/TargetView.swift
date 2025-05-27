//
//  TargetView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/27/24.
//

import SwiftUI
import CoreMotion
import AudioToolbox

struct TargetView: View {
    private var motionManager = MotionManager.shared
    @State private var currentQuaternion: CMQuaternion?
    @State private var targetQuaternion: CMQuaternion?
    @State private var repCount: Double = 0.0
    @State private var rangeAccuracy = 10.0
    @State private var isMeasuring = false
    @State private var timer: Timer?
    @State private var repAlreadyCounted = false
    

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(height: 400)
                    .foregroundStyle(didReachTarget() ? .green : .red)
                
                VStack {
                    Text("\(repCount, specifier: "%.0f")")
                        .font(.system(size: 72))
                        .bold()
                    
                    Text(isMeasuring ? "Target Set" : "Set Target")
                        .font(.system(size: 24))
                }
            }
            .onTapGesture {
                if !isMeasuring {
                    setTarget()
                } else {
                    reset()
                }
            }
            .padding()
            
            VStack {
                Slider(
                    value: $rangeAccuracy,
                    in: 2...15
                )
                Text("Target Accuracy: ±\(rangeAccuracy, specifier: "%.1f")°")
            }
            .padding()
            
            VStack {
                Button(isMeasuring ? "Reset" : "Set Target") {
                    if !isMeasuring {
                        setTarget()
                    } else {
                        reset()
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(.blue)
            }
        }
        .onAppear {
            startUpdates()
        }
        .onDisappear {
            stopUpdates()
        }
    }
    
    private func startUpdates() {
        motionManager.startUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            currentQuaternion = motionManager.currentQuaternion
//            if isMeasuring {
//                if didReachTarget() {
//                    // Nothing needed here — the `didReachTarget()` already vibrates and adds rep
//                }
//            }
        }
    }
    
    private func stopUpdates() {
        timer?.invalidate()
        timer = nil
        motionManager.stopUpdates()
    }
    
    private func setTarget() {
        targetQuaternion = currentQuaternion
        isMeasuring = true
    }
    
    private func reset() {
        targetQuaternion = nil
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
    
    private func calculateRotationAngle(from start: CMQuaternion, to end: CMQuaternion) -> Double {
        let dot = start.x * end.x + start.y * end.y + start.z * end.z + start.w * end.w
        let clampedDot = min(1.0, max(-1.0, dot))
        let angleRadians = 2 * acos(clampedDot)
        var angleDegrees = angleRadians * 180 / .pi
        
        if angleDegrees > 180 {
            angleDegrees = 360 - angleDegrees
        }
        
        return angleDegrees
    }
}

#Preview {
    TargetView()
}
