//
//  Measure.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-18.
//

import Foundation

struct Measure: Decodable {
    let measureExpression: String
    var measureQuantity: Double
    var measureUnit: String
    var relativeWeight: Double
}
