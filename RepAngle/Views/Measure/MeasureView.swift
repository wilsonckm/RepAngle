//
//  ContentView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/25/24.
//

import SwiftUI
import CoreMotion
import AudioToolbox
import SwiftData

struct MeasureView: View {
    
    // Swift Data
    @Environment(\.modelContext) private var context
    
    // Gyroscope Data
    private var motionManager = MotionManager.shared
    
    // Measure
    @State private var initialQuaternion: CMQuaternion?
    @State private var rotationAngle: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var isMeasuring: Bool = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isMeasuring
        }
    }
    // Target
    @State private var currentQuaternion: CMQuaternion?
    @State private var targetQuaternion: CMQuaternion?
    @State private var isTargetSet: Bool = false
    @State private var repCount: Double = 0.0
    @State private var rangeAccuracy = 5.0
    @State private var repAlreadyCounted = false
    
    // Record
    @State private var recordedReadings: [AngleReading] = []
    @State private var isRecording: Bool = false
    @State private var showingHistory = false
    @State private var showingInfo = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingHistory = true
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.primary)
                        .font(.system(size: 24))
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                Spacer()
                Button(action: {
                    showingInfo = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.primary)
                    
                        .font(.system(size: 24))
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            Spacer()
            
            //Measure
            ZStack {
                
                Circle()
                    .opacity(0.01)
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(isMeasuring ? .red : .green)
                VStack (alignment: .center){
                    Text("\(rotationAngle, specifier: "%.0f")°")
                        .font(.system(size: 72))
                        .bold()
                        .padding(.vertical, -10)
                    Divider()
                        .padding(.horizontal,20)
                    Text("\(180 - rotationAngle, specifier: "%.0f" )°")
                        .font(.system(size: 64))
                        .padding(.vertical, -10)
                }
            }
            .onTapGesture {
                motionManager.startUpdates()
                if !isMeasuring {
                    startMeasuring()
                } else {
                    addMeasurement()
                    stopMeasuring()
                    resetTarget()
                }
            }
            HStack {
                Button(action: {
                    toggleRecording()
//                    isRecording.toggle()
                }) {
                    Image(systemName: "record.circle")
                        .foregroundStyle(isRecording ? .red : .gray)
                        .font(.system(size: 24))
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                Spacer()
                
                Button(action: {
                    if !isTargetSet {
                        setTarget()
                    } else {
                        resetTarget()
                        stopMeasuring()
                        
                    }
                }) {
                    Image(systemName: "scope")
                        .foregroundStyle(isTargetSet ? (isWithinTargetRange() ? .green : .red) : .gray)
                        .font(.system(size: 24))
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .disabled(!isMeasuring)
                .opacity(isMeasuring ? 1 : 0.5)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 50)
                .foregroundStyle(isWithinTargetRange() ? .green : .gray)
            
            Text("\(repCount, specifier: "%.0f")")
            VStack {
                Slider(
                    value: $rangeAccuracy,
                    in: 2...15
                )
                Text("Target Accuracy: ±\(rangeAccuracy, specifier: "%.0f")°")
            }
            .padding()
            
        }
        
        .padding()
        .onDisappear {
            // Always clean up timer if the view disappears
            timer?.invalidate()
            // Turns off screen
            UIApplication.shared.isIdleTimerDisabled = false
            stopMeasuring()
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
                .presentationDetents([.height(300), .large])
                .presentationDragIndicator(.visible)
                .background(.clear)
                .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $showingInfo) {
            InfoView()
                .presentationDetents([.height(300), .large])
                .presentationDragIndicator(.visible)
                .presentationDetents([.large])
        }
    }
    
    // Measure
  
    private func startMeasuring() {
        rotationAngle = 0.0
        isMeasuring = true
        motionManager.startUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Task { @MainActor in
                self.initialQuaternion = self.motionManager.currentQuaternion
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    Task { @MainActor in
                        guard let start = self.initialQuaternion else { return }
                        self.currentQuaternion = self.motionManager.currentQuaternion
                        
                        if let current = self.currentQuaternion {
                            let newAngle = self.calculateRotationAngle(from: start, to: current)
                            self.rotationAngle = newAngle
                            
                            // Captures readings if recording
                            if self.isRecording {
                                let reading = AngleReading(angle: self.rotationAngle, timestamp: Date())
                                self.recordedReadings.append(reading)
                            }
                        }
                        
                        if self.isTargetSet {
                            _ = self.didReachTarget()
                        }
                    }
                }
            }
        }
    }
    
    private func stopMeasuring() {
        timer?.invalidate()
        timer = nil
        isMeasuring = false
        motionManager.stopUpdates()
    }
    
    private func calculateRotationAngle(from start: CMQuaternion, to end: CMQuaternion) -> Double {
        let dot = start.x * end.x + start.y * end.y + start.z * end.z + start.w * end.w
        let clampedDot = min(1.0, max(-1.0, dot)) // Clamp to prevent NaN
        let angleRadians = 2 * acos(clampedDot)
        var angleDegrees = angleRadians * 180 / .pi
        
        // Always take the smaller angle
        if angleDegrees > 180 {
            angleDegrees = 360 - angleDegrees
        }
        return angleDegrees
    }
    
    
    // Target
    
    private func setTarget() {
        targetQuaternion = currentQuaternion
        isTargetSet = true
    }
    
    private func resetTarget() {
        targetQuaternion = nil
        isTargetSet = false
        repCount = 0
        isMeasuring = false
    }
  
    private func didReachTarget() -> Bool {
        guard let target = targetQuaternion, let current = currentQuaternion else {
            return false
        }

        let angleDifference = calculateRotationAngle(from: target, to: current)
        let isWithinRange = angleDifference <= rangeAccuracy

        if isWithinRange && !repAlreadyCounted {
//            DispatchQueue.main.async {
//                vibrate()
//                addRep()
//                repAlreadyCounted = true
//            }
            repAlreadyCounted = true
            vibrate()
            addRep()
        } else if !isWithinRange {
//            DispatchQueue.main.async {
//                repAlreadyCounted = false
//            }
            repAlreadyCounted = false
        }

        return isWithinRange
    }
    
    private func isWithinTargetRange() -> Bool {
        guard let target = targetQuaternion, let current = currentQuaternion else {
            return false
        }
        let angleDifference = calculateRotationAngle(from: target, to: current)
        return angleDifference <= rangeAccuracy
    }
    
    private func addRep() {
        DispatchQueue.main.async {
            repCount += 1
        }
    }
    
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    
    // Record
    private func toggleRecording() {
        if isRecording {
            // Stopping: save measurement
            saveRecording()
            recordedReadings.removeAll()
            isRecording = false
            // Stop measuring
            stopMeasuring()
        } else {
            // Starting
            recordedReadings.removeAll()
            isRecording = true
            if !isMeasuring {
                startMeasuring()
            }
        }
    }

    private func saveRecording() {
        guard !recordedReadings.isEmpty else { return }
        
        let measurement = MeasurementItem(name: "Recorded Session", timestamp: Date())
        measurement.readings.append(contentsOf: recordedReadings)
        context.insert(measurement)
    }
    
    // SwiftData Functions
    func addMeasurement() {
        let measurement = MeasurementItem(name: "Quick Measure", timestamp: Date())
        let reading = AngleReading(angle: rotationAngle, timestamp: Date())
        measurement.readings.append(reading)
        
        context.insert(measurement)
    }
}

#Preview {
    MeasureView()
}
