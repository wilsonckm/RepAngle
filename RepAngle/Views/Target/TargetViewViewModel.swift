//
//  TargetViewViewModel.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/28/24.
//

import Foundation


class TargetViewViewModel: ObservableObject {
    
//    private var motionManager = MotionManager.shared
//    private var timer: Timer?
//    
//    @Published var currentX: Double = 0.0
//    @Published var currentY: Double = 0.0
//    @Published var currentZ: Double = 0.0
//    @Published var initialX: Double = 0.0
//    @Published var initialY: Double = 0.0
//    @Published var initialZ: Double = 0.0
//    @Published var endX: Double = 0.0
//    @Published var endY: Double = 0.0
//    @Published var endZ: Double = 0.0
//    @Published var measurement: Double = 0
//    
//    @Published var repCount: Int = 0
//    
//    
//    init() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//            self?.updateMotionData()
////            self?.didReachRange()
//        }
//    }
//    
//    private func updateMotionData() {
//          currentX = formatRawValueToDegrees(rawValue: motionManager.x)
//          currentY = formatRawValueToDegrees(rawValue: motionManager.y)
//          currentZ = formatRawValueToDegrees(rawValue: motionManager.z)
//      }
//    
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
}
