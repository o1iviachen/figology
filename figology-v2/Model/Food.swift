//
//  Food.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//

import Foundation

struct FoodData: Decodable {
    let common: [FoodRequest]
    let branded: [FoodRequest]
}

struct Food: Codable {
    let food: String
    let fibrePerGram: Double
    let brandName: String
    let measures: [Measure]
    var selectedMeasure: Measure
    var multiplier: Double
}

struct FoodRequest: Decodable {
    let food_name: String
}

struct FibreData: Decodable {
    let foods: [RawFood]
}

// add keys
// enum CodingKeys: String, CodingKey {
//case foodName = "food_name"
//case nfDietaryFiber = "nf_dietary_fiber"
//}

struct RawFood: Decodable {
    let food_name: String
    let nf_dietary_fiber: Double
    let brand_name: String?
    let alt_measures: [RawMeasure]
    var serving_unit: String
    var serving_qty: Int
    var serving_weight_grams: Double
}



