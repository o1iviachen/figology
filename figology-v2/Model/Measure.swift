//
//  Measure.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-18.
//

import Foundation

struct Measure: Codable {
    let measureExpression: String
    let measureMass: Double
}

struct RawMeasure: Decodable {
    let serving_weight: Double
    let measure: String
    let qty: Int
}
