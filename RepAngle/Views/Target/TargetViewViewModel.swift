//
//  TargetViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/28/24.
//

import Foundation


class TargetViewViewModel: ObservableObject {
    
    private var motionManager = MotionManager.shared
    private var timer: Timer?
    
    @Published var currentX: Double = 0.0
    @Published var currentY: Double = 0.0
    @Published var currentZ: Double = 0.0
    @Published var initialTargetX: Double = 0.0
    @Published var initialTargetY: Double = 0.0
    @Published var initialTargetZ: Double = 0.0
    @Published var endTargetX: Double = 0.0
    @Published var endTargetY: Double = 0.0
    @Published var endTargetZ: Double = 0.0
    @Published var measurement: Double = 0.0
    @Published var setRangeX: Double = 0.0
    @Published var setRangeY: Double = 0.0
    @Published var setRangeZ: Double = 0.0

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateMotionData()
        }
    }
    
    private func updateMotionData() {
        currentX = motionManager.currentX
        currentY = motionManager.currentY
        currentZ = motionManager.currentZ
      }
    
    var isMotionActive: Bool {
        motionManager.isDeviceMotionActive
    }
    
    func calculateGreatestDifference(initialValueX: Double,
                                     endValueX: Double,
                                     initialValueY: Double,
                                     endValueY: Double,
                                     initialValueZ: Double,
                                     endValueZ: Double)-> Double{
            let differences = [
            abs(initialValueX - endValueX),
            abs(initialValueY - endValueY),
            abs(initialValueZ - endValueZ)
        ]
        return differences.max() ?? 0.0
    }
    
//    func greatestCurrentValue() -> Double {
//        let greatestValue = [
//                currentX,
//                currentY,
//                currentZ,
//        ]
//        return greatestValue.max() ?? 0.0
//    }

//    func identifyAxisAndInitialValue(initialValueX: Double, endValueX: Double, initialValueY: Double, endValueY: Double, initialValueZ: Double, endValueZ: Double) -> (axis: String, initialValue: Double) {
//        let differences = [
//            ("X", initialValueX, abs(initialValueX - endValueX)),
//            ("Y", initialValueY, abs(initialValueY - endValueY)),
//            ("Z", initialValueZ, abs(initialValueZ - endValueZ))
//        ]
//        
//        if let maxDifference = differences.max(by: { $0.2 < $1.2 }) {
//            return (maxDifference.0, maxDifference.1)
//        } else {
//            return ("", 0.0)
//        }
//    }

    
    // Check if value has reached the same position given a certain range/inaccuracy
    func didReachFreeTarget(accuracy: Double) -> Bool {
        if (abs(currentX - endTargetX) <= accuracy)
            && (abs(currentY - endTargetY) <= accuracy)
            && (abs(currentZ - endTargetZ) <= accuracy) {
            return true
        } else {
            return false
        }
    }

    //Check if current value has moved a given range based on intial and end targets
    
    func setTargetRange() {
        setRangeX = initialTargetX - endTargetX
        setRangeY = initialTargetY - endTargetY
        setRangeZ = initialTargetZ - endTargetZ
    }
    
    func largestRange() -> Double {
        let largestNumber = [
            abs(setRangeX),
            abs(setRangeY),
            abs(setRangeZ)
        ]
        return largestNumber.max() ?? 0.0
    }
    
//Only Considers linear movement
//    func didReachTargetRange(accuracy: Double) -> Bool {
//        let targetX = initialTargetX + setRangeX
//        let targetY = initialTargetY + setRangeY
//        let targetZ = initialTargetZ + setRangeZ
//
//        return (abs(currentX - targetX) <= accuracy)
//            && (abs(currentY - targetY) <= accuracy)
//            && (abs(currentZ - targetZ) <= accuracy)
//    }


    
    func withinTargetRange(accuracy: Double) -> Bool {
        
        return (abs(currentX - setRangeX) >= accuracy)
            || (abs(currentY - setRangeY) >= accuracy)
            || (abs(currentZ - setRangeZ) >= accuracy)
    }
    
    //To do:
//    func iterateRep() {
//        repCount += 1
//    }
}
