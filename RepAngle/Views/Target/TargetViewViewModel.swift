//
//  TargetViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/28/24.
//

import Foundation
//import UIKit, For haptic feedback, however, opted for AudioToolBox for increased tactile feedback

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
