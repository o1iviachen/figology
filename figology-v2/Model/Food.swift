//
//  Food.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//

import Foundation

struct Food: Decodable {
    let food: String
    var brandName: String
    let fibre: Int
    var measures: [Measure]
    var selectedMeasure: Measure
    
    
    let mealType: String
}
