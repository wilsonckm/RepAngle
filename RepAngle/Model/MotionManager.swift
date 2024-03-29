////
////  MotionManager.swift
////  RepAngle
////
////  Created by Wilson Chan on 1/26/24.
////
//
import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    //Motion Manager declared as a singleton and accessable globally
    static let shared = MotionManager()
    private var motionManager = CMMotionManager()
    
    //Raw Vales
    private var x = 0.0
    private var y = 0.0
    private var z = 0.0
    
    var isDeviceMotionActive: Bool {
            motionManager.isDeviceMotionActive
        }
    
    init() {
        //Captures data on an interval. Mainly for battery consumption.
        motionManager.deviceMotionUpdateInterval = 1/15
        // initialize on startup
        motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main ) { [weak self] data, error in
            //Data is optional therefore necessary to unwrap
            guard let motion = data?.attitude else { return }
            self?.x = motion.pitch
            self?.y = motion.roll
            self?.z = motion.yaw
        }
    }

//Start function that doubles as a force recalibration function as we are using xAritraryCorrectedZVertical.
    func startUpdates() {
                motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { [weak self] data, error in
                    //Data is optional therefore necessary to unwrap
                    guard let motion = data?.attitude else { return }
                    self?.x = motion.pitch
                    self?.y = motion.roll
                    self?.z = motion.yaw
                }
        }
    
//Stop Function
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
//Formatted values -- values to be used in other views:
        var currentX: Double {
            formatRawValueToDegrees(rawValue: x)
        }
        var currentY: Double {
            formatRawValueToDegrees(rawValue: y)
        }
    
        var currentZ: Double {
            formatRawValueToDegrees(rawValue: z)
        }
    
//Formula to format raw value into degrees to tenth place.
   private func formatRawValueToDegrees(rawValue: Double) -> Double {
        let degrees = radiansToDegrees(radians: rawValue)
        let rounded = roundToTenth(value: degrees)
        return rounded
    }
    
//Raw to degree helper functions
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    
    private func roundToTenth(value: Double) -> Double {
        return (value * 10).rounded()/10
    }
    
    
    
    
}
