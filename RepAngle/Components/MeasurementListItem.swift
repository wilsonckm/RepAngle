//
//  MeasurementListItem.swift
//  RepAngle
//
//  Created by Wilson Chan on 6/10/25.
//

import SwiftUI
import Charts

struct MeasurementListItem: View {
    
    let measurement: MeasurementItem
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with name + edit button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(measurement.name)
                            .font(.title2)
                        Spacer()
                        Button(action: onEdit) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(.plain)
                    }
                    Text(formatter.string(from: measurement.timestamp))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            // Single-measurement case
            if measurement.readings.count == 1,
               let singleMeasurement = measurement.readings.first {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Angle")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("\(singleMeasurement.angle, specifier: "%.0f")°")
                            .font(.title)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Complement")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("\(180 - singleMeasurement.angle, specifier: "%.0f")°")
                            .font(.title)
                            .bold()
                    }
                }
            }
            // Multi-reading case: plot + stats
            else if !measurement.readings.isEmpty {
                let sampleInterval: Double = 0.05 // seconds between readings
                let sortedReadings = measurement.readings.sorted { $0.timestamp < $1.timestamp }
                Chart {
                    ForEach(Array(sortedReadings.enumerated()), id: \.element.id) { index, reading in
                        LineMark(
                            x: .value("Time (s)", Double(index) * sampleInterval),
                            y: .value("Angle", Int(reading.angle))
                        )
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: FloatingPointFormatStyle<Double>()
                            .precision(.fractionLength(0))) // whole seconds
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 100)
                
                if let min = measurement.readings.map(\.angle).min(),
                   let max = measurement.readings.map(\.angle).max() {
                    HStack {
                        Text("Min: \(Int(min))°")
                        Spacer()
                        Text("Max: \(Int(max))°")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            // No data
            else {
                Text("No angle data")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.clear)
        )
    }
    
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
}

#Preview {
//    MeasurementListItem()
}

