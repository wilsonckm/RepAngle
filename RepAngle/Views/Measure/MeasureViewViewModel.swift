//
//  MeasureViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import Foundation

class MeasureViewViewModel: ObservableObject {
//    @Published var motionManager = MotionManager()
    private var motionManager = MotionManager.shared
    private var timer: Timer?
    @Published var currentX: Double = 0.0
    @Published var currentY: Double = 0.0
    @Published var currentZ: Double = 0.0
    @Published var initialX: Double = 0.0
    @Published var initialY: Double = 0.0
    @Published var initialZ: Double = 0.0
    @Published var endX: Double = 0.0
    @Published var endY: Double = 0.0
    @Published var endZ: Double = 0.0
    @Published var measurement: Double = 0
    @Published var isWithinRange: Bool = false
    @Published var repCount: Int = 0
    
//    @Published var currentDate = Date.now
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Timer required to force a SwiftUI view update for the continuous current X, Y, Z values. Previous attempts to use computed properties did not update
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateMotionData()
        }
    }
    
    private func updateMotionData() {
          currentX = formatRawValueToDegrees(rawValue: motionManager.x)
          currentY = formatRawValueToDegrees(rawValue: motionManager.y)
          currentZ = formatRawValueToDegrees(rawValue: motionManager.z)
      }

    
/*  Formated degrees of continuous measurement.
    Computed property allows value to recaluclate every time it is accessed
    Always using current value of self
 
        !!!!Update: When moving coreMotion to separate file, computed properties would not trigger SwiftUI view update. See above for fix.
 */
       
//    var currentX: Double {
//        formatRawValueToDegrees(rawValue: motionManager.x)
//    }
//    var currentY: Double {
//        formatRawValueToDegrees(rawValue: motionManager.y)
//    }
//    
//    var currentZ: Double {
//        formatRawValueToDegrees(rawValue: motionManager.z)
//    }
    
    //Checks if device motion is active
    var isMotionActive: Bool {
        motionManager.isDeviceMotionActive
    }
    
    //Manual control to start and stop --> Prevents battery waste
    func startMotionUpdates() {
           motionManager.startUpdates()
       }

       func stopMotionUpdates() {
           motionManager.stopUpdates()
       }
    
    
    //Formula to format raw value into degrees to tenth place.
    func formatRawValueToDegrees(rawValue: Double) -> Double {
        let degrees = radiansToDegrees(radians: rawValue)
        let rounded = roundToTenth(value: degrees)
        return rounded
    }
    
    //Raw to degree helper functions
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    
    func roundToTenth(value: Double) -> Double {
        return (value * 10).rounded()/10
    }
    
/*  Formula to return the greatest difference between initial and end value.
 
    Use case: To allow user to measure range of motion of a joint
    Rationale: It is anticipated that the user would move most in a direction they would like to measure
 */
    
    func calculateGreatestDifference() -> Double {
        let differences = [
            abs(initialX - endX),
            abs(initialY - endY),
            abs(initialZ - endZ)
        ]
        return differences.max() ?? 0.0
    }
    
    
    
    //To do:
    func iterateRep() {
        repCount += 1
    }
    
    
}
