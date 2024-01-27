//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI

struct MeasureView: View {
    @StateObject private var viewModel = MeasureViewViewModel()
    
//    @State private var currentX: Double = 0.0
//    @State private var currentY: Double = 0.0
//    @State private var currentZ: Double = 0.0
//    @State private var initialX: Double = 0.0
//    @State private var initialY: Double = 0.0
//    @State private var initialZ: Double = 0.0
//    @State private var endX: Double = 0.0
//    @State private var endY: Double = 0.0
//    @State private var endZ: Double = 0.0
//    @State private var measurement: Double = 0
//    
//    @State private var isWithinRange: Bool = false
//    @State private var repCount: Int = 0
//    
//    @State private var currentDate = Date.now
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        
//        if (abs(roundToTenth(value: radiansToDegrees(radians: motion.x)) - viewModel.endX) <= 6)
//            && (abs(roundToTenth(value: radiansToDegrees(radians: motion.y)) - viewModel.endY) <= 6)
//            && (abs(roundToTenth(value: radiansToDegrees(radians: motion.z)) - viewModel.endZ) <= 6) {
//                    RoundedRectangle(cornerRadius: 25.0)
//                        .fill(.green)
//                } else {
//                    RoundedRectangle(cornerRadius: 25.0)
//                        .fill(.blue)
//                }
        
        
        
        Text("\(viewModel.currentDate)")
            .onReceive(viewModel.timer) { input in
                viewModel.currentDate = input
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
                    Text("\(viewModel.currentX, specifier: "%.2f")")
                    Text("\(viewModel.currentY, specifier: "%.2f")")
                    Text("\(viewModel.currentX, specifier: "%.2f")")
                }
                .padding()
                
                
                VStack {
                    Text("Starting Position")
                        .bold()
                    Text("\(viewModel.initialX, specifier: "%.2f")")
                    Text("\(viewModel.initialY, specifier: "%.2f")")
                    Text("\(viewModel.initialZ, specifier: "%.2f")")
                }
                .padding()
                
                
                VStack {
                    Text("End Position")
                        .bold()
                    Text("\(viewModel.endX, specifier: "%.2f")")
                    Text("\(viewModel.endY, specifier: "%.2f")")
                    Text("\(viewModel.endZ, specifier: "%.2f")")
                    
                }
                .padding()
                
                VStack {
                    Text("Measurement")
                        .bold()
//                    Text("\(viewModel.measurement, specifier: "%.2f")")
                }
                
                VStack {
                    Text("Rep Count: \(viewModel.repCount)")
                }
                
                VStack{
                    Button("Start Position"){
//                        viewModel.initialX = roundToTenth(value:radiansToDegrees(radians:motion.x))
//                        viewModel.initialY = roundToTenth(value:radiansToDegrees(radians:motion.y))
//                        viewModel.initialZ = roundToTenth(value:radiansToDegrees(radians:motion.z))
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .padding()
                    .tint(.green)
                    
                    Button("End Position"){
//                        viewModel.endX = roundToTenth(value:radiansToDegrees(radians:motion.x))
//                        viewModel.endY = roundToTenth(value:radiansToDegrees(radians:motion.y))
//                        viewModel.endZ = roundToTenth(value:radiansToDegrees(radians:motion.z))
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .padding()
                    .tint(.red)
                    
                    Button("Measure"){
//                        viewModel.measurement = calculateGreatestDifference()
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .padding()
                    .tint(.blue)
                }
            }
    }
    
    //#Preview {
    //    ContentView()
    //}
