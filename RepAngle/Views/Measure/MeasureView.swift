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
            ZStack {
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 350)
                    .foregroundColor(isMeasuring ? .red : .green)
                VStack {
                    Text(isMeasuring ? "End Position" : "Start Position")
                    if viewModel.initialX <= 10.0 {
                        //Display Z
                        Text(isMeasuring ? "\(viewModel.differenceFromStartZ, specifier: "%.1f")" : "\(viewModel.measurement, specifier: "%.1f")")
                            .font(.system(size: 72))
                            .bold()
                        
                        Text(isMeasuring ? "\(viewModel.subtract180FromDifferenceZ, specifier: "%.1f")" : "\(viewModel.subtract180(value: viewModel.measurement), specifier: "%.1f")")
                            .font(.system(size: 36))
                            .bold()
                    } else {
                        //Display X
                        Text(isMeasuring ? "\(viewModel.differenceFromStartX, specifier: "%.1f")": "\(viewModel.measurement, specifier: "%.1f")")
                            .font(.system(size: 72))
                            .bold()
                        Text(isMeasuring ? "\(viewModel.subtract180FromDifferenceX, specifier: "%.1f")" : "\(viewModel.subtract180(value: viewModel.measurement), specifier: "%.1f")")
                            .font(.system(size: 36))
                            .bold()
                    }
                }
            }
            .onTapGesture {
                if isMeasuring == false {
                    viewModel.getStartPosition()
                    isMeasuring.toggle()
                } else {
                    viewModel.getEndPosition()
                    viewModel.measurement = viewModel.calculateGreatestDifference()
                    isMeasuring.toggle()
                }
            }
//            VStack {
//                Text("Measurement")
//                    .bold()
//                Text("\(viewModel.measurement, specifier: "%.1f")")
//                Text("\(viewModel.subtract180(value: viewModel.measurement), specifier: "%.1f")")
//            }
            
            VStack {
                Text("\(viewModel.currentX)")
                Text("\(viewModel.currentY)")
                Text("\(viewModel.currentZ)")
            }
            VStack{
                Button(isMeasuring ? "End Position" : "Start Position"){
                    
                    if isMeasuring == false {
                        viewModel.getStartPosition()
                        isMeasuring.toggle()
                    } else {
                        viewModel.getEndPosition()
                        viewModel.measurement = viewModel.calculateGreatestDifference()
                        isMeasuring.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .tint(isMeasuring ? .red : .green)
            }
            .padding()
        }
    }
}

    //#Preview {
    //    ContentView()
    //}
