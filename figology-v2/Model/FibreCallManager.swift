//
//  FibreCallManager.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-18.
//


import Foundation


struct FibreCallManager {
    
    let headers = [
        "Content-Type": "application/x-www-form-urlencoded",
        "x-app-id": "7156443e",
        "x-app-key": "f506fd53cfd1a9006ed4a98e320a725b",
        "x-remote-user-id": "0"
    ]
    
    
    func prepareRequest(requestString: String?, url: String, httpMethod: String) -> URLRequest? {
        // Prepare request; code from https://docx.syndigo.com/developers/docs/natural-language-for-nutrients
        let url = URL(string: url)!
        var request = URLRequest(url: url)

        // If string is not nil
        if let query = requestString {
            if httpMethod.uppercased() == "GET" {
                // For GET, append query to URL
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = [URLQueryItem(name: "nix_item_id", value: query)]
                guard let finalURL = components?.url else { return nil }
                request = URLRequest(url: finalURL)
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            } else {
                let bodyString = "query=\(query)"
                let bodyData = bodyString.data(using: .utf8)
                
                request.httpMethod = httpMethod
                request.allHTTPHeaderFields = headers
                request.httpBody = bodyData
            }
            return request
        }
        return nil
    }
    
    
    func performFoodRequest(request: URLRequest?, completion: @escaping ([[String?]]) -> Void) {
        var fibreRequests: [[String?]] = []
        
        // Make sure request is not nil
        if let safeRequest = request {
            
            // Create a data task with the given request
            let task = URLSession.shared.dataTask(with: safeRequest) { (data, response, error) in
                
                // If data is received successfully
                if let safeData = data {
                    
                    // Parse JSON into food names
                    fibreRequests = self.parseFoodJSON(foodData: safeData)
                }
                
                // Call the completion handler possibly with food names later used for fibre requests
                completion(fibreRequests)
            }
            
            // Start task
            task.resume()
        }
    }
    
    
    func parseFoodJSON(foodData: Data) -> [[String?]] {
        var foodList: [[String?]] = [[], []]
        let decoder = JSONDecoder()
        
        // Try to decode results from Nutritionix API from searching a food string
        do {
            let decodedData = try decoder.decode(FoodData.self, from: foodData)
            
            // Append food names to the food list
            for food in decodedData.common {
                foodList[0].append(food.food_name)
            }
            for food in decodedData.branded {
                foodList[1].append(food.nix_item_id)
            }
        } catch {}
        return foodList
    }
    
    
    func performFibreRequest(request: URLRequest?, completion: @escaping (Food?) -> Void) {
        var fibreFood: Food? = nil
        
        // Make sure request is not nil
        if let safeRequest = request {
            
            // Create a data task with the given request
            let task = URLSession.shared.dataTask(with: safeRequest) { (data, response, error) in
                
                // If data is received successfully
                if let safeData = data {
                    
                    //print(String(decoding: safeData, as: UTF8.self))
                    // Parse JSON into a Food object
                    if let food = self.parseFibreJSON(fibreData: safeData) {
                        fibreFood = food
                    }
                }
                
                // Call the completion handler possibly with functional Food object users can log
                completion(fibreFood)
            }
            
            // Start task
            task.resume()
        }
    }
    
    
    // unbranded only
    func parseFibreJSON(fibreData: Data) -> Food? {
        let decoder = JSONDecoder()
        
        // Try to decode food-specific nutrient data from Nutritionix API
        do {
            let decodedData = try decoder.decode(FibreData.self, from: fibreData)
            
            // Create Food object from Nutrionix API JSON
            let food = decodedData.foods[0]
            let foodName = food.food_name
            let brandName = food.brand_name ?? "unbranded"
            let servingFibre = food.nf_dietary_fiber
            let servingQuantity = food.serving_qty
            let servingUnit = food.serving_unit
            let servingGrams = food.serving_weight_grams
            
            // Create property values for the Food object's selected measure
            let servingExpression = "\(servingQuantity) \(servingUnit)"
            let servingMeasure = Measure(measureExpression: servingExpression, measureMass: servingGrams)
            
            // Calculate the fibre per gram for the Food object
            let fibrePerGram = servingFibre/servingGrams
            
            var altMeasures: [Measure] = []
            altMeasures.append(servingMeasure)
            
            // Create Measure objects from Nutrionix API JSON
            if let toParseMeasures = food.alt_measures {
                for altMeasure in toParseMeasures {
                    let measureQuantity = altMeasure.qty
                    let measure = altMeasure.measure
                    let measureMass = altMeasure.serving_weight
                    let altMeasureExpression = "\(measureQuantity) \(measure)"
                    let parsedMeasure = Measure(measureExpression: altMeasureExpression, measureMass: measureMass)
                    altMeasures.append(parsedMeasure)
                }
            }
            
            let parsedFood = Food(food: foodName, fibrePerGram: fibrePerGram, brandName: brandName, measures: altMeasures, selectedMeasure: servingMeasure, multiplier: 1.0, consumptionTime: nil)
            return parsedFood
        }
        
        // If an error occurs, return nil
        catch {
            return nil
        }
    }
}

