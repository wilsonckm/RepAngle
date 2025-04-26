//
//  UpdatedMeasureViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 4/25/25.
//

import Foundation
import CoreMotion

class UpdatedMeasureViewViewModel: ObservableObject {
    private var motionManager = MotionManager.shared
    @Published var isMeasuring = false
    @Published var measurement: Double = 0.0
    @Published var plane: String = "Saggital Plane/Frontal"
    
    private var initialQuaternion: CMQuaternion?

    init() {
        // You might still want a timer if you later want live updating (optional)
    }

    func measureButtonFunction() {
        if isMeasuring == false {
            reset()
            getStartPosition()
            planeOfMeasurement()
            isMeasuring.toggle()
        } else {
            getEndPosition()
            isMeasuring.toggle()
        }
    }
    
    func reset() {
        initialQuaternion = nil
        measurement = 0.0
        isMeasuring = false
        plane = "Saggital Plane/Frontal"
    }
    
    func getStartPosition() {
        initialQuaternion = motionManager.currentQuaternion
    }
    
    func getEndPosition() {
        if let initial = initialQuaternion, let current = motionManager.currentQuaternion {
            measurement = calculateRotationDifference(from: initial, to: current)
        }
    }
    
    private func calculateRotationDifference(from start: CMQuaternion, to end: CMQuaternion) -> Double {
        let dot = start.x * end.x + start.y * end.y + start.z * end.z + start.w * end.w
        let clampedDot = min(1.0, max(-1.0, dot))
        let angleRadians = 2 * acos(clampedDot)
        return angleRadians * 180 / .pi // Return degrees
    }
    
    func planeOfMeasurement() {
        // Optional: you could update this using quaternion info too if needed.
        plane = "General Rotation"
    }
    
    func subtract180(value: Double) -> Double {
        return 180 - value
    }
    
    var subtract180FromDifference: Double {
        subtract180(value: measurement)
    }
}
