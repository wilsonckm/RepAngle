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
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 350)
                    .foregroundColor(viewModel.isMeasuring ? .red : .green)
                VStack {
                    Text(viewModel.isMeasuring ? "Tap to Complete Measurement" : "Tap to Measure:")
                        .padding()
                    Text(viewModel.isMeasuring ? "End Position" : "Start Position")
                    Text(viewModel.isMeasuring ? "\(viewModel.calculateGreatestDifference(), specifier: "%.1f")" : "\(viewModel.measurement, specifier: "%.1f")")
                        .font(.system(size: 72))
                        .bold()
                    
                    Text(viewModel.isMeasuring ? "\(viewModel.subtract180FromDifference, specifier: "%.1f")" : "\(viewModel.subtract180(value: viewModel.measurement), specifier: "%.1f")")
                        .font(.system(size: 36))
                        .bold()
                    Text(viewModel.plane)
                }
            }
            .onTapGesture {
                viewModel.measureButtonFunction()
            }
            
            //            VStack {
            //                Text("\(viewModel.currentX)")
            //                Text("\(viewModel.currentY)")
            //                Text("\(viewModel.currentZ)")
            //            }
            //            VStack{
            //                Button("Reset"){
            //                    viewModel.reset()
            //                }
            //                .buttonStyle(.borderedProminent)
            //                .foregroundStyle(.white)
            //                .tint(.blue)
            //                .controlSize(.large)
//        }
            .padding()
        }
    }
}

    //#Preview {
    //    ContentView()
    //}
