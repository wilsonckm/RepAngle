//
//  EditMeasurementView.swift
//  RepAngle
//
//  Created by Wilson Chan on 6/11/25.
//

import SwiftUI

struct EditMeasurementView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Bindable var item: MeasurementItem

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $item.name)
//                    if let firstReading = item.readings.first {
//                        Text("Angle: \(firstReading.angle, specifier: "%.0f")°")
//                    } else {
//                        Text("No angle data")
//                    }
                    DatePicker("Timestamp", selection: $item.timestamp)
                }

                Section {
                    Button("Save") {
                        dismiss()
                    }

                    Button("Delete", role: .destructive) {
                        context.delete(item)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    EditMeasurementView()
//}
