//
//  MeasurementItem.swift
//  RepAngle
//
//  Created by Wilson Chan on 5/17/25.
//

import Foundation
import SwiftData

@Model
class MeasurementItem {
    var name: String
    var timestamp: Date
    
    @Relationship var readings: [AngleReading] = []
    
    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

@Model
class AngleReading {
    var angle: Double
    var timestamp: Date
    
    @Relationship(inverse: \MeasurementItem.readings) var measurement: MeasurementItem?
    
    init(angle: Double, timestamp: Date) {
        self.angle = angle
        self.timestamp = timestamp
    }
}
