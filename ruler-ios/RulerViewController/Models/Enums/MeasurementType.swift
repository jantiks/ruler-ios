//
//  MeasurementType.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/13/21.
//

import Foundation

enum MeasurementType {
    
    case meters
    case santimeters
    case feets
    case inches
    
    func getRatioInMeters() -> Double {
        switch self {
            case .meters:
                return 1
            case .santimeters:
                return 100
            case .feets:
                return 3.28
            case .inches:
                return 39.37
        }
    }
    
    func getShortName() -> String {
        switch self {
            case .meters:
                return "m"
            case .santimeters:
                return "sm"
            case .feets:
                return "ft"
            case .inches:
                return "in"
        }
    }
    
    mutating func next() {
        switch self {
            case .meters:
                self = .santimeters
            case .santimeters:
                self = .feets
            case .feets:
                self = .inches
            case .inches:
                self = .meters
        }
    }
}
