//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI
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

struct ContentView: View {
    @StateObject private var motion = MotionManager()
    
    @State private var initialX: Double = 0.0
    @State private var initialY: Double = 0.0
    @State private var initialZ: Double = 0.0
    
    @State private var endX: Double = 0.0
    @State private var endY: Double = 0.0
    @State private var endZ: Double = 0.0
    
    @State private var measurement: Double = 0
    
    @State private var didReachAngle: Bool = false
    @State private var repCount: Int = 0
    
    var body: some View {
        
        Circle()
            .fill(didReachAngle ? .red : .green )
            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                            updateCurrentValues()
                            checkAngle()
        
        VStack {
            HStack {
                VStack {
                    Text("Continuous Measurement")
                        .bold()
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.x)), specifier: "%.2f")")
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.y)), specifier: "%.2f")")
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.z)), specifier: "%.2f")")
                }
                Spacer()
            }
        }
        .padding()
        
        VStack {
            HStack {
                VStack {
                    Text("Starting Position")
                        .bold()
                    Text("\(initialX, specifier: "%.2f")")
                    Text("\(initialY, specifier: "%.2f")")
                    Text("\(initialZ, specifier: "%.2f")")
                }
                Spacer()
            }
        }
        .padding()
        
        
            VStack {
                HStack {
                    VStack {
                        Text("Measurement")
                            .bold()
                        Text("\(measurement, specifier: "%.2f")")
                    }
            }
        }
        
        
        
        
        
        
        VStack{
            Button("Start Position"){
                initialX = roundToTenth(value:radiansToDegrees(radians:motion.x))
                initialY = roundToTenth(value:radiansToDegrees(radians:motion.y))
                initialZ = roundToTenth(value:radiansToDegrees(radians:motion.z))
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .padding()
            .tint(.green)
            
            Button("End Position"){
                endX = roundToTenth(value:radiansToDegrees(radians:motion.x))
                endY = roundToTenth(value:radiansToDegrees(radians:motion.y))
                endZ = roundToTenth(value:radiansToDegrees(radians:motion.z))
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .padding()
            .tint(.red)
            
            Button("Measure"){
                measurement = calculateGreatestDifference()
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .padding()
            .tint(.blue)
        }
    }
    
    
    
    func calculateGreatestDifference() -> Double {
        let differences = [
            abs(initialX - endX),
            abs(initialY - endY),
            abs(initialZ - endZ)
        ]
        return differences.max() ?? 0.0
    }
        
        func checkAngle() {
            didReachAngle = (abs(currentX - endX) <= 2) || (abs(currentY - endY) <= 2) || (abs(currentZ - endZ) <= 2)
        }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    func roundToTenth(value: Double) -> Double {
        return (value * 10).rounded()/10
    }
}

//#Preview {
//    ContentView()
//}
