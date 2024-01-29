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
    @Published var initialX: Double = 0.0
    @Published var initialY: Double = 0.0
    @Published var initialZ: Double = 0.0
    @Published var endX: Double = 0.0
    @Published var endY: Double = 0.0
    @Published var endZ: Double = 0.0

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateMotionData()
//            self?.didReachRange()
        }
    }
    
    private func updateMotionData() {
        //Moved raw-values-to-degrees formatting to MotionManager Class
        currentX = motionManager.currentX
        currentY = motionManager.currentY
        currentZ = motionManager.currentZ
      }
    
//    // Check if value has reached end range
//    func didReachRange(accuracy: Double) -> Bool {
//        if (abs(currentX - endX) <= accuracy)
//            && (abs(currentY - endY) <= accuracy)
//            && (abs(currentZ - endZ) <= accuracy) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    // Check if value has reached end range
    func didReachRange(accuracy: Double) -> Bool {
        if (abs(currentX - endX) <= accuracy)
            && (abs(currentY - endY) <= accuracy)
            && (abs(currentZ - endZ) <= accuracy) {
            return true
        } else {
            return false
        }
    }
    
    //To do:
//    func iterateRep() {
//        repCount += 1
//    }
}
