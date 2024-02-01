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
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(height: 400)
                    .foregroundStyle(viewModel.didReachFreeTarget(accuracy: rangeAccuracy) ? .green : .red )
                VStack {
                    Text("\(viewModel.repCount, specifier: "%.0f")")
                        .font(.system(size: 72))
                        .bold()
                    Text(isResetToggle ? "Target Set" : "Set Target")
                        .font(.system(size: 24))
                }
            }
            .onChange(of: viewModel.didReachFreeTarget(accuracy: rangeAccuracy)) { oldValue, newValue in
                viewModel.addRep()
            }
            .onTapGesture {
                if isResetToggle == false {
                    viewModel.setTargetRange()
                    isResetToggle = true
                } else {
                    viewModel.reset()
                    rangeAccuracy = 10.0
                    isResetToggle = false
                }
            }
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
                        if isResetToggle == false {
                            viewModel.setTargetRange()
                            isResetToggle = true
                        } else {
                            viewModel.reset()
                            rangeAccuracy = 10.0
                            isResetToggle = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .tint(.blue)
                }
            }
        }
    }
}

#Preview {
    TargetView()
}
