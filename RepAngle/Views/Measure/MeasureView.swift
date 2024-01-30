//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI

struct MeasureView: View {
    @StateObject private var viewModel = MeasureViewViewModel()
    @State private var isMeasuring = false
    
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
                Text("\(viewModel.subtract180(value: viewModel.measurement), specifier: "%.1f")")
            }
            VStack{
                Button(isMeasuring ? "End Position" : "Start Position"){
                    
                    if isMeasuring == false {
                        viewModel.initialX = viewModel.currentX
                        viewModel.initialY = viewModel.currentY
                        viewModel.initialZ = viewModel.currentZ
                        isMeasuring.toggle()
                    } else {
                        viewModel.endX = viewModel.currentX
                        viewModel.endY = viewModel.currentY
                        viewModel.endZ = viewModel.currentZ
                        viewModel.measurement = viewModel.calculateGreatestDifference(
                            initialValueX: viewModel.initialX,
                            endValueX: viewModel.endX,
                            initialValueY: viewModel.initialY,
                            endValueY: viewModel.endY,
                            initialValueZ: viewModel.initialZ,
                            endValueZ: viewModel.endZ)
                        isMeasuring.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(isMeasuring ? .red : .green)
            }
        }
        .padding()
    }
}
    //#Preview {
    //    ContentView()
    //}
