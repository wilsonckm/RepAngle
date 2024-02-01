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
    
    var subtract180FromDifferenceX: Double {
        180 - differenceFromStartX
    }
    
    var subtract180FromDifferenceZ: Double {
        180 - differenceFromStartZ
    }
    
/*  Formula to return the greatest difference between initial and end value.
 
    Use case: To allow user to measure range of motion of a joint
    Rationale: Updated to prevent edge case where values change drastically in certain positions. Initial start position of X will be used to measure "intent" of measurement plane. Roll/Y was eliminated as measurement around a longitudinal axis did not seem appropriate for measurement along frontal/saggital planes of the human body.
 
  "Pitch/X is a rotation around a lateral axis that passes through the device from side to side."
  
  "Roll/Y is a rotation around a longitudinal axis that passes through the device from its top to bottom."
                 
  "Yaw/Z is a rotation around an axis that runs vertically through the device. It is perpendicular to the body of the device, with its origin at the center of gravity and directed toward the bottom of the device."
 
 */
    
    func calculateGreatestDifference() -> Double {
        if initialX <= 10.0 {
            let difference = abs(initialZ - currentZ)
            return difference
        } else {
            let difference = abs(initialX - currentX)
            return difference
        }
    }
    
    func subtract180(value: Double) -> Double {
        return 180 - value
    }
}
