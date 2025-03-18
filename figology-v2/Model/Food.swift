//
//  Food.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//

import Foundation

struct Food: Decodable {
    let food: String
    let fibrePerGram: Int
    let brandName: String
    let measures: [Measure]
    var selectedMeasure: Measure
    var multiplier: Double
    var mealType: String
}
