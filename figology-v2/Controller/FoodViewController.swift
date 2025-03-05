//
//  FoodViewController.swift
//  figology-v2
//
//  Created by su huang on 2025-03-05.
//

import Foundation
import UIKit
import Firebase

struct Food: Codable {
    let food: String
    var brandName: String
    let fibreAmount: Int
    var measures: [Measure]
    let consumedAmount: Double
    let consumedUnit: String
}

struct Measure: Codable, Equatable {
    var measureQuantity: Double
    var measureUnit: String
    var relativeWeight: Double
    static func == (lhs: Measure, rhs: Measure) -> Bool {
            // Compare all relevant properties to determine equality
            return lhs.measureQuantity == rhs.measureQuantity &&
                   lhs.measureUnit == rhs.measureUnit &&
                   lhs.relativeWeight == rhs.relativeWeight
            // Add other properties if needed
        }
}
