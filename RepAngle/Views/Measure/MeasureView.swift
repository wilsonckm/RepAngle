//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI

struct MeasureView: View {
    @StateObject private var motion = MotionManager()
    @State private var currentX: Double = 0.0
    @State private var currentY: Double = 0.0
    @State private var currentZ: Double = 0.0
    @State private var initialX: Double = 0.0
    @State private var initialY: Double = 0.0
    @State private var initialZ: Double = 0.0
    @State private var endX: Double = 0.0
    @State private var endY: Double = 0.0
    @State private var endZ: Double = 0.0
    @State private var measurement: Double = 0
    
    @State private var isWithinRange: Bool = false
    @State private var repCount: Int = 0
    
    @State private var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        
                if (abs(roundToTenth(value: radiansToDegrees(radians: motion.x)) - endX) <= 6)
                    && (abs(roundToTenth(value: radiansToDegrees(radians: motion.y)) - endY) <= 6)
                    && (abs(roundToTenth(value: radiansToDegrees(radians: motion.z)) - endZ) <= 6) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.green)
                } else {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.blue)
                }
        Text("\(currentDate)")
            .onReceive(timer) { input in
                            currentDate = input
                        }
        
        
        //        if (isWithinRange == (abs(roundToTenth(value: radiansToDegrees(radians: motion.x)) - endX) <= 6)
        //                    && (abs(roundToTenth(value: radiansToDegrees(radians: motion.y)) - endY) <= 6)
        //                    && (abs(roundToTenth(value: radiansToDegrees(radians: motion.z)) - endZ) <= 6)) {
        //                    RoundedRectangle(cornerRadius: 25.0)
        //                        .fill(.green)
        //                } else {
        //                    RoundedRectangle(cornerRadius: 25.0)
        //                        .fill(.red)
        //                }
        
//        RoundedRectangle(cornerRadius: 25.0)
//            .fill(isWithinRange ? Color.green : Color.red)
//            .onAppear {
//                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//                    updateRangeStatus()
//                }
                //            .onAppear {
                //                isWithinRange = (abs(roundToTenth(value: radiansToDegrees(radians: motion.x)) - endX) <= 6)
                //                             && (abs(roundToTenth(value: radiansToDegrees(radians: motion.y)) - endY) <= 6)
                //                             && (abs(roundToTenth(value: radiansToDegrees(radians: motion.z)) - endZ) <= 6)
                //            }
                
                VStack {
                    Text("Continuous Measurement")
                        .bold()
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.x)), specifier: "%.2f")")
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.y)), specifier: "%.2f")")
                    Text("\(roundToTenth(value:radiansToDegrees(radians:motion.z)), specifier: "%.2f")")
                }
                .padding()
                
                
                VStack {
                    Text("Starting Position")
                        .bold()
                    Text("\(initialX, specifier: "%.2f")")
                    Text("\(initialY, specifier: "%.2f")")
                    Text("\(initialZ, specifier: "%.2f")")
                }
                .padding()
                
                
                VStack {
                    Text("End Position")
                        .bold()
                    Text("\(endX, specifier: "%.2f")")
                    Text("\(endY, specifier: "%.2f")")
                    Text("\(endZ, specifier: "%.2f")")
                    
                }
                .padding()
                
                VStack {
                    Text("Measurement")
                        .bold()
                    Text("\(measurement, specifier: "%.2f")")
                }
                
                VStack {
                    Text("Rep Count: \(repCount)")
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
        
        func iterateRep() {
            repCount += 1
        }
        
        func radiansToDegrees(radians: Double) -> Double {
            return radians * 180 / .pi
        }
        
        func roundToTenth(value: Double) -> Double {
            return (value * 10).rounded()/10
        }
        
        func updateRangeStatus() {
            // Update this to fetch real-time gyroscope data
            let currentX = roundToTenth(value: radiansToDegrees(radians: motion.x))
            let currentY = roundToTenth(value: radiansToDegrees(radians: motion.y))
            let currentZ = roundToTenth(value: radiansToDegrees(radians: motion.z))
            
            isWithinRange = (abs(currentX - endX) <= 6)
            && (abs(currentY - endY) <= 6)
            && (abs(currentZ - endZ) <= 6)
        }
        
    }
    
    //#Preview {
    //    ContentView()
    //}
