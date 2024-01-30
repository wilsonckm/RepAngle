//
//  TargetView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/27/24.
//

import SwiftUI

struct TargetView: View {
    @StateObject private var viewModel = TargetViewViewModel()
    @State private var rangeAccuracy = 10.0
    @State private var isEditing = false
    @State private var isResetToggle = false
    @State private var isPauseToggle = false
    
    var body: some View {
        VStack {
            Text("Device Motion Active: \(viewModel.isMotionActive.description)")
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(height: 400)
                    .foregroundStyle(viewModel.didReachFreeTarget(accuracy: rangeAccuracy) ? .green : .red )
                VStack {
                    Text("\(viewModel.measurement, specifier: "%.1f")")
                        .font(.system(size: 72))
                        .bold()
                    Text("Free Target")
                        .font(.system(size: 24))
                }
            }
//            VStack {
//                            HStack {
//                                Text("Range")
//                                Text("\(viewModel.setRangeX, specifier: "%.1f")")
//                                Text("\(viewModel.setRangeY, specifier: "%.1f")")
//                                Text("\(viewModel.setRangeZ, specifier: "%.1f")")
//                                Text("Largest Range: \(viewModel.largestRange())")
//                            }
//                        }
//                ZStack {
//                    RoundedRectangle(cornerRadius: 25.0)
//                        .frame(height: 200)
//                        .foregroundStyle(viewModel.withinTargetRange(accuracy: rangeAccuracy) ? .green : .red )
//                    VStack {
//                        Text("\(viewModel.measurement, specifier: "%.1f")")
//                            .font(.system(size: 72))
//                            .bold()
//                        Text("Set Range")
//                            .font(.system(size: 24))
//
//                    }
//            }
//            VStack {
//                            HStack {
//                                Text("Current")
//                                Text("\(viewModel.currentX, specifier: "%.1f")")
//                                Text("\(viewModel.currentY, specifier: "%.1f")")
//                                Text("\(viewModel.currentZ, specifier: "%.1f")")
//                            }
//                        }
//            VStack {
//                            HStack {
//                                Text("Initial")
//                                Text("\(viewModel.initialTargetX, specifier: "%.1f")")
//                                Text("\(viewModel.initialTargetY, specifier: "%.1f")")
//                                Text("\(viewModel.initialTargetZ, specifier: "%.1f")")
//                            }
//                        }
//            VStack {
//                            HStack {
//                                Text("End")
//                                Text("\(viewModel.endTargetX, specifier: "%.1f")")
//                                Text("\(viewModel.endTargetY, specifier: "%.1f")")
//                                Text("\(viewModel.endTargetZ, specifier: "%.1f")")
//                            }
//                        }
            VStack {
                Slider(
                    value: $rangeAccuracy,
                    in: 2...15,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                )
                Text("Target Accuracy: +/- \(rangeAccuracy, specifier: "%.1f")")
            }
            .padding()
            VStack {
                HStack {
                    Button(isResetToggle ? "Reset" : "Set Target") {
//                        viewModel.startMotionUpdates()
                        if isResetToggle == false {
                            viewModel.endTargetX = viewModel.currentX
                            viewModel.endTargetY = viewModel.currentY
                            viewModel.endTargetZ = viewModel.currentZ
                            isResetToggle = true
                        } else {
//                            viewModel.stopMotionUpdates()
                            viewModel.initialTargetX = 0.0
                            viewModel.initialTargetY = 0.0
                            viewModel.initialTargetZ = 0.0
                            viewModel.endTargetX = 0.0
                            viewModel.endTargetY = 0.0
                            viewModel.endTargetZ = 0.0
                            viewModel.measurement = 0.0
                            rangeAccuracy = 10.0
                            isResetToggle = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .tint(.blue)
                }
//                HStack {
//                    Button(isPauseToggle ? "Resume" : "Pause") {
//                        if isPauseToggle == false {
//                            viewModel.stopMotionUpdates()
//                            isPauseToggle.toggle()
//                        } else {
//                            viewModel.startMotionUpdates()
//                            isPauseToggle.toggle()
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .foregroundStyle(.white)
//                    .tint(.blue)
//                }
                //To do:
//                HStack {
//                    Button("15 deg"){
//                        
//                    }
//                    Button("30 deg"){
//                        
//                    }
//                    Button("45 deg"){
//                        
//                    }
//                    Button("60 deg"){
//                        
//                    }
//                }
            }
        }
    }
}

#Preview {
    TargetView()
}
