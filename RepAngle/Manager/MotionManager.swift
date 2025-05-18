////
////  MotionManager.swift
////  RepAngle
////
////  Created by Wilson Chan on 1/26/24.
////
//
import Foundation
import CoreMotion
import Observation

@MainActor
@Observable class MotionManager {
    static let shared = MotionManager()
    private var motionManager = CMMotionManager()
    
    var currentQuaternion: CMQuaternion?
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // Smooth updates
        startUpdates()
    }
    
    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main) { [weak self] data, error in
            guard let motion = data?.attitude else { return }
            self?.currentQuaternion = motion.quaternion
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
