//
//  Food.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//  refer to dr angela

import Foundation

struct Food: Codable {
    /**
     A structure that organises properties of food items, and allows properties to be readable and writable.
     - parameter food (String): The name of the food item.
     - parameter fibrePerGram (Double): The amount of fibre per gram for the food item.
     - parameter brandName (String): The brand for the food item.
     - parameter measures (Array): An array of potential measurement units.
     - parameter selectedMeasure (Measure): The measurement unit selected by the user.
     - parameter multiplier (Double): A value to convert between measures.
     - parameter consumptionTime (Optional String): The timestamp at which the food was consumed, if applicable.
     */
    
    let food: String
    let fibrePerGram: Double
    let brandName: String
    let measures: [Measure]
    var selectedMeasure: Measure
    var multiplier: Double
    var consumptionTime: String?
}

struct FoodData: Decodable {
    /**
     A structure that reads the food data from a JSON response and separates the food items in different categories.
     - parameter common (Array): An array of common food items.
     - parameter branded (Array): An array of branded food products.
     */
    let common: [CommonFoodRequest]
    let branded: [BrandedFoodRequest]
}

struct CommonFoodRequest: Decodable {
    /**
    A structure that reads common food item returned from a JSON response.
    - parameter food_name (String): The name of the food item.
    */
    
    let food_name: String
}

struct BrandedFoodRequest: Decodable {
    /**
    A structure that reads a branded food product returned from a JSON response.
    - parameter nix_item_id (String): The unique Nutritionix API identifier for the branded item in the food database.
    */
    
    let nix_item_id: String
}

struct FibreData: Decodable {
    /**
     A structure that reads the root object returned by a JSON response.
     - parameter food (Array): An array of raw food items containing fibre and measurement information.
     */
    
    let foods: [RawFood]
}

struct RawFood: Decodable {
    /**
     A structure that organizes the properties of food items read from a JSON reponse.
     - parameter food_name (String): The name of the food item.
     - parameter nf_dietary_fiber (Double): The amount of fibre per unit.
     - parameter brand_name (Optional String): The brand of the food, if applicable.
     - parameter alt_measures (Optional Array): An array of alternative measurement units, if available.
     - parameter serving_qty (Int): The default serving quantity.
     - parameter serving_unit (String): The unit for the default serving quantity.
     - parameter serving_weight_grams (Double): The weight in grams for the default serving size.
     */
    
    let food_name: String
    let nf_dietary_fiber: Double
    let brand_name: String?
    let alt_measures: [RawMeasure]?
    let serving_qty: Int
    let serving_unit: String
    let serving_weight_grams: Double
}
