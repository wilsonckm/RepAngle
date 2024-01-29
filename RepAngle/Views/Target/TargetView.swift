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
    
    var body: some View {
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
//                .foregroundStyle(viewModel.didReachRange(accuracy: rangeAccuracy) ? .green : .red )
        }
    }
}

#Preview {
    TargetView()
}
