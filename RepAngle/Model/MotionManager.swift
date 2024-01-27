//
//  MotionManager.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/26/24.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
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
}
