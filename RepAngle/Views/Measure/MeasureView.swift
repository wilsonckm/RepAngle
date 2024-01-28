//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI

struct MeasureView: View {
    @StateObject private var viewModel = MeasureViewViewModel()
    
    var body: some View {
        //
        //        Text("\(viewModel.currentDate)")
        //            .onReceive(viewModel.timer) { input in
        //                viewModel.currentDate = input
        //                        }
        
        
        //
        VStack {
            Text("Device Motion Active: \(viewModel.isMotionActive.description)")
            VStack {
                Text("Continuous Measurement")
                    .bold()
                Text("\(viewModel.currentX, specifier: "%.1f")")
                Text("\(viewModel.currentY, specifier: "%.1f")")
                Text("\(viewModel.currentZ, specifier: "%.1f")")
            }
            .padding()
            
            
            VStack {
                Text("Starting Position")
                    .bold()
                Text("\(viewModel.initialX, specifier: "%.1f")")
                Text("\(viewModel.initialY, specifier: "%.1f")")
                Text("\(viewModel.initialZ, specifier: "%.1f")")
            }
            .padding()
            
            
            VStack {
                Text("End Position")
                    .bold()
                Text("\(viewModel.endX, specifier: "%.1f")")
                Text("\(viewModel.endY, specifier: "%.1f")")
                Text("\(viewModel.endZ, specifier: "%.1f")")
                
            }
            .padding()
            
            VStack {
                Text("Measurement")
                    .bold()
                Text("\(viewModel.measurement, specifier: "%.1f")")
            }
            
            VStack {
                Text("Rep Count: \(viewModel.repCount)")
            }
            
            VStack{
                Button("Start Position"){
                    viewModel.initialX = viewModel.currentX
                    viewModel.initialY = viewModel.currentY
                    viewModel.initialZ = viewModel.currentZ
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .padding()
                .tint(.green)
                
                Button("End Position"){
                    viewModel.endX = viewModel.currentX
                    viewModel.endY = viewModel.currentY
                    viewModel.endZ = viewModel.currentZ
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .padding()
                .tint(.red)
                
                Button("Measure"){
                    viewModel.measurement = viewModel.calculateGreatestDifference()
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .padding()
                .tint(.blue)
            }
            Button("Start CoreMotion"){
                viewModel.startMotionUpdates()
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .padding()
            .tint(.blue)
            
            Button("Stop CoreMotion"){
                viewModel.stopMotionUpdates()
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
