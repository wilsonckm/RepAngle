//
//  MeasureViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import Foundation

class MeasureViewViewModel: ObservableObject {
    //Access the singleton instance of MotionManager
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
    @Published var measurement: Double = 0.0
    @Published var isMeasuring = false
    
//Timer required to force a SwiftUI view update for the continuous current X, Y, Z values. Previous attempts to use computed properties did not update
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateMotionData()
        }
    }
    
    private func updateMotionData() {
        //Moved raw-values-to-degrees formatting to MotionManager Class
        currentX = motionManager.currentX
        currentY = motionManager.currentY
        currentZ = motionManager.currentZ
    }
/*  Formatted degrees of continuous measurement.
    Computed property allows value to recaluclate every time it is accessed
    Always using current value of self
 
        !!!!Update: When moving coreMotion to separate file, computed properties would not trigger SwiftUI view update. See above for fix: Used timer to force an update in motion data.
 */
       
//    var currentX: Double {
//        motionManager.currentX
//    }
//    var currentY: Double {
//        motionManager.currentY
//    }
//
//    var currentZ: Double {
//        motionManager.currentZ
//    }
//    
    
//Checks if device motion is active
    var isMotionActive: Bool {
        motionManager.isDeviceMotionActive
    }
    
//Manual control to start and stop --> Prevents battery waste --> Removed to prevent user from forgetting to manually start Motion Manager
    func startMotionUpdates() {
        motionManager.startUpdates()
    }

    func stopMotionUpdates() {
        motionManager.stopUpdates()
    }
    
    func getStartPosition() {
        //occasional ui race condition bug where UI would update to previous coordinates as
//        reset()
        //Start Motion updates used to force recalibration of Z axis
//        startMotionUpdates()
//        reset()
        initialX = currentX
        initialY = currentY
        initialZ = currentZ
    }
    
    func getEndPosition() {
        endX = currentX
        endY = currentY
        endZ = currentZ
        
//        startMotionUpdates()

    }
    
//Computed properties --> Computed properties itself will not trigger swiftUI update but since the timer above is forcing and update, these values below will continuously be updated on screen.
    
    var differenceFromStartX: Double {
        abs(initialX - currentX)
    }
    var differenceFromStartY: Double {
        abs(initialY - currentY)
    }
    var differenceFromStartZ: Double {
        abs(initialZ - currentZ)
    }
    
//Get the difference from 180
    var subtract180FromDifferenceX: Double {
        180 - differenceFromStartX
    }
    
    var subtract180FromDifferenceY: Double {
        180 - differenceFromStartY
    }
    
    var subtract180FromDifferenceZ: Double {
        180 - differenceFromStartZ
    }
    
    var subtract180FromDifference: Double {
        180 - calculateGreatestDifference()
    }
    

//Reset function
    func reset() {
//        currentX = 0.0
//        currentY = 0.0
//        currentZ = 0.0
        initialX = 0.0
        initialY = 0.0
        initialZ = 0.0
//        endX  = 0.0
//        endY  = 0.0
//        endZ  = 0.0
//        measurement  = 0.0
    }
    
//Main Measure Button Function
    func measureButtonFunction() {
        if isMeasuring == false {
            //Occasional bug?? where UI updates to previous values before force recalibration can finish. Reset function to start from scratch
            
//            startMotionUpdates()
            getStartPosition()
            isMeasuring.toggle()
        } else {
            getEndPosition()
            measurement = calculateGreatestDifference()
            isMeasuring.toggle()
            reset()
//            stopMotionUpdates()
//            startMotionUpdates()
        }
    }
/*  Formula to return the greatest difference between initial and end value.
 
    Use case: To allow user to measure range of motion of a joint
    Rationale: Updated to prevent edge case where values change drastically in certain positions. Initial start position of X will be used to measure "intent" of measurement plane. Roll/Y was eliminated as measurement around a longitudinal axis did not seem appropriate for measurement along frontal/saggital planes of the human body.
 
  "Pitch/X is a rotation around a lateral axis that passes through the device from side to side."
  
  "Roll/Y is a rotation around a longitudinal axis that passes through the device from its top to bottom."
                 
  "Yaw/Z is a rotation around an axis that runs vertically through the device. It is perpendicular to the body of the device, with its origin at the center of gravity and directed toward the bottom of the device."
 
 
 Main purpose of using pitch as the main measurement angle is due to gimbal lock: when the pitch angle approaches ±90 degrees, causing an indistinguishability between yaw and roll. This caused drastic changes in measured angles in certain use cases. An inherent limitation of Euler angles.
 
 To prevent improper use and maintain accuracy of measurements, video demos of app is recommended to standarize measurement.
 
 Additional tip would be to maintain points of interest when setting start/end measurements and limit extraneous axis movements.
 
 Another possibility would be to use quaternions as they do not have the same limitations as euler angles. '
 
 
 For future consideration, possibly look into SLERP or spherical trigonometry as it may offer greater accuracy without the technical limitations of Euler Angles.
 
 */
    
    func calculateGreatestDifference() -> Double {
        //Measure rotation in the Z axis. Possible use case would be to measure rotation about the transverse plane of the body (when standing), i.e. Cervical rotation/thoracic rotation
        if abs(initialX.rounded()) < 10.0 && abs(initialY.rounded()) < 10.0 {
            let difference = abs(initialZ - currentZ)
            return difference
        
            
            //Formulas below are to account for measurement in the X axis. While Y would determine which formulas to use in order to account for negative initial degree measurements as Pitch/X will be the measurement angle.
            
            //When X passes 90 degrees
        } else if (initialY <= 0 && endY >= 0) || (initialY > 0 && endY < 0) {
            let difference = (90 - initialX) + abs(90 - currentX)
            return difference
            
            //When inital X is negative
        } 
//            else if (initialY < 0 && endY < 0) {
//            let difference = abs(initialX) + currentX
//            return difference
//            
//            //All other instances
//        }
        else {
            let difference = abs(initialX - currentX)
            return difference
        }
    }
    
    func planeOfMeasurement() -> String {
        if abs(currentX.rounded()) < 10.0 && abs(currentY.rounded()) < 10.0 {
            let plane = "Transverse Plane"
            return plane
            
        } else {
            let plane = "Saggital Plane/Frontal"
            return plane
        }
    }
    
    func subtract180(value: Double) -> Double {
        return 180 - value
    }
}
