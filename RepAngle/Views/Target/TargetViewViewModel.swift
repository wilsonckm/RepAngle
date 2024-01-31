//
//  TargetViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/28/24.
//

import Foundation
//For haptic feedback
import UIKit
//For increased Vibrate feedback
import AudioToolbox


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
//    @Published var measurement: Double = 0.0
//    @Published var setRangeX: Double = 0.0
//    @Published var setRangeY: Double = 0.0
//    @Published var setRangeZ: Double = 0.0
    @Published var repCount: Double = 0.0

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
    
        func startMotionUpdates() {
               motionManager.startUpdates()
           }

        func stopMotionUpdates() {
               motionManager.stopUpdates()
           }
    
//    func calculateGreatestDifference(initialValueX: Double,
//                                     endValueX: Double,
//                                     initialValueY: Double,
//                                     endValueY: Double,
//                                     initialValueZ: Double,
//                                     endValueZ: Double)-> Double{
//            let differences = [
//            abs(initialValueX - endValueX),
//            abs(initialValueY - endValueY),
//            abs(initialValueZ - endValueZ)
//        ]
//        return differences.max() ?? 0.0
//    }
    
    
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
    
//Haptic Feedback --> Too weak. Updating to use AudioToolbox
    func vibrate() {
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
//        generator.impactOccurred()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
//Count Rep
    func addRep(){
        if endTargetX != 0.0 && endTargetY != 0.0 && endTargetZ != 0.0 {
            //not 1 to to prevent iteration on true/false change. Additionally, may potentially be used to measure partial reps?
            repCount += 0.4999
        }
    }
    
// Check if value has reached the same position given a certain range/inaccuracy
    func didReachFreeTarget(accuracy: Double) -> Bool {
        //Added != 0.0 to prevent vibrate on reset.
        if endTargetX != 0.0 && endTargetY != 0.0 && endTargetZ != 0.0
            && (abs(currentX - endTargetX) <= accuracy)
            && (abs(currentY - endTargetY) <= accuracy)
            && (abs(currentZ - endTargetZ) <= accuracy) {
            vibrate()
            return true
        } else {
            return false
        }
    }
    
//Set Target Range
    func setTargetRange() {
        endTargetX = currentX
        endTargetY = currentY
        endTargetZ = currentZ
    }
    
//Reset
    func reset() {
        initialTargetX = 0.0
        initialTargetY = 0.0
        initialTargetZ = 0.0
        endTargetX = 0.0
        endTargetY = 0.0
        endTargetZ = 0.0
        repCount = 0
    }
    
}
