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
    @Published var plane: String = "Saggital Plane/Frontal"
    
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
        initialX = currentX
        initialY = currentY
        initialZ = currentZ
    }
    
    func getEndPosition() {
        endX = currentX
        endY = currentY
        endZ = currentZ
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
        //Reset values initial and end to current position
        getStartPosition()
        getEndPosition()
        measurement  = 0.0
        isMeasuring = false
        plane = "Saggital Plane/Frontal"
    }
    
//Main Measure Button Function
    func measureButtonFunction() {
        if isMeasuring == false {
            //Occasional bug where UI updates to previous values before force recalibration can finish. Reset function to start from scratch
            reset()
            getStartPosition()
            planeOfMeasurement()
            isMeasuring.toggle()
        } else {
            getEndPosition()
            measurement = calculateGreatestDifference()
            isMeasuring.toggle()
//            stopMotionUpdates()
//            startMotionUpdates()
        }
    }
    
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
    
            //All other possibilities
        } else {
            let difference = abs(initialX - currentX)
            return difference
        }
    }
    
    func planeOfMeasurement() {
        if abs(currentX.rounded()) < 10.0 && abs(currentY.rounded()) < 10.0 {
            plane = "Transverse Plane"
        } else {
            plane = "Saggital Plane/Frontal"
        }
    }
    
    func subtract180(value: Double) -> Double {
        return 180 - value
    }
}
