//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI

struct MeasureView: View {
    @StateObject private var viewModel = MeasureViewViewModel()
    
//    @State var isWithinRange: Bool = false
//    @State var rangeAccuracy: Double = 2.0
    @State private var rangeAccuracy = 10.0
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            Text("Device Motion Active: \(viewModel.isMotionActive.description)")
            VStack {
                Text("Continuous Measurement")
                    .bold()
                
                Text("\(viewModel.currentX, specifier: "%.1f")")
                Text("\(viewModel.currentY, specifier: "%.1f")")
                Text("\(viewModel.currentZ, specifier: "%.1f")")
            }
            VStack {
                Text("Starting Position")
                    .bold()
                Text("\(viewModel.initialX, specifier: "%.1f")")
                Text("\(viewModel.initialY, specifier: "%.1f")")
                Text("\(viewModel.initialZ, specifier: "%.1f")")
            }
            VStack {
                Text("End Position")
                    .bold()
                Text("\(viewModel.endX, specifier: "%.1f")")
                Text("\(viewModel.endY, specifier: "%.1f")")
                Text("\(viewModel.endZ, specifier: "%.1f")")
                
            }
            VStack {
                Text("Measurement")
                    .bold()
                Text("\(viewModel.measurement, specifier: "%.1f")")
            }
            VStack {
                Text("Rep Count: \(viewModel.repCount)")
            }
            VStack {
                Slider(
                    value: $rangeAccuracy,
                    in: 2...10,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                )
                Text("\(rangeAccuracy)")
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 100, height: 20)
                    .foregroundStyle(viewModel.didReachRange(accuracy: rangeAccuracy) ? .green : .red )
            }
            
            VStack{
                Button("Start Position"){
                    viewModel.initialX = viewModel.currentX
                    viewModel.initialY = viewModel.currentY
                    viewModel.initialZ = viewModel.currentZ
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(.green)
                
                Button("End Position"){
                    viewModel.endX = viewModel.currentX
                    viewModel.endY = viewModel.currentY
                    viewModel.endZ = viewModel.currentZ
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(.red)
                
                Button("Measure"){
                    viewModel.measurement = viewModel.calculateGreatestDifference()
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(.blue)
            }
            Button("Start CoreMotion"){
                viewModel.startMotionUpdates()
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.blue)
            
            Button("Stop CoreMotion"){
                viewModel.stopMotionUpdates()
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)

            .tint(.blue)
        }
        .padding()
    }
}
    //#Preview {
    //    ContentView()
    //}
