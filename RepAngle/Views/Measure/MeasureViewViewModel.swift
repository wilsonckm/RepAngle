//
//  MeasureViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import Foundation

class MeasureViewViewModel: ObservableObject {
//    @Published private var motionManager = MotionManager()

    @Published var initialX: Double = 0.0
    @Published var initialY: Double = 0.0
    @Published var initialZ: Double = 0.0
    @Published var endX: Double = 0.0
    @Published var endY: Double = 0.0
    @Published var endZ: Double = 0.0
    @Published var measurement: Double = 0
    @Published var isWithinRange: Bool = false
    @Published var repCount: Int = 0
    
    @Published var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
/*  Formated degrees of continuous measurement.
    Computed property allows value to recaluclate every time it is accessed
    Always using current value of self
 
 */
    
    var currentX: Double {
        formatRawValueToDegrees(rawValue: MotionManager.shared.x)
    }
    var currentY: Double {
        formatRawValueToDegrees(rawValue: MotionManager.shared.y)
    }
    
    var currentZ: Double {
        formatRawValueToDegrees(rawValue: MotionManager.shared.z)
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
