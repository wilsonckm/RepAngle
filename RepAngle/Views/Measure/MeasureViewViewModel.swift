//
//  MeasureViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import Foundation
import CoreMotion

//class MotionManager: ObservableObject {
//}

class MeasureViewViewModel: ObservableObject {
    
    @Published var motionManager = CMMotionManager()
    
    //Raw values
    @Published var x = 0.0
    @Published var y = 0.0
    @Published var z = 0.0
    
    init() {
        //Captures data on an interval. Mainly for battery consumption.
        motionManager.deviceMotionUpdateInterval = 1/15
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            //Data is optional therefore necessary to unwrap
            guard let motion = data?.attitude else { return }
            self?.x = motion.roll
            self?.y = motion.pitch
            self?.z = motion.yaw
        }
    }
    
    
    @Published var initialX: Double = 0.0
    @Published var initialY: Double = 0.0
    @Published var initialZ: Double = 0.0
    @Published var endX: Double = 0.0
    @Published var endY: Double = 0.0
    @Published var endZ: Double = 0.0
//    @Published var measurement: Double = 0
    @Published var isWithinRange: Bool = false
    @Published var repCount: Int = 0
    
    @Published var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
/*  Formated degrees of continuous measurement.
    Computed property allows value to recaluclate every time it is accessed
    Always using current value of self
 
 */
    
    var currentX: Double {
        formatRawValueToDegrees(rawValue: self.x)
    }
    var currentY: Double {
        formatRawValueToDegrees(rawValue: self.y)
    }
    
    var currentZ: Double {
        formatRawValueToDegrees(rawValue: self.z)
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
