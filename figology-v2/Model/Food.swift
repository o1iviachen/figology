//
//  Food.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//  refer to dr angela

import Foundation

struct Food: Codable {
    let food: String
    let fibrePerGram: Double
    let brandName: String
    let measures: [Measure]
    var selectedMeasure: Measure
    var multiplier: Double
    var consumptionTime: String?
}

struct FoodData: Decodable {
    let common: [FoodRequest]
    let branded: [FoodRequest]
}

struct FoodRequest: Decodable {
    let food_name: String
}

struct FibreData: Decodable {
    let foods: [RawFood]
}

struct RawFood: Decodable {
    let food_name: String
    let nf_dietary_fiber: Double
    let brand_name: String?
    let alt_measures: [RawMeasure]
    let serving_qty: Int
    let serving_unit: String
    let serving_weight_grams: Double
}



