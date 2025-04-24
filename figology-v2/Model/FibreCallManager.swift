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
            "x-app-id": "c1358ca9",
            "x-app-key": "2fc3f23569c0ca6b14767cab5f262e30",
            "x-remote-user-id": "0"
    ]
    
    func prepareFoodRequest(foodSearch: String) -> URLRequest {
        
        // Prepare request; code from https://docx.syndigo.com/developers/docs/natural-language-for-nutrients
        let query = foodSearch
        let url = URL(string: "https://trackapi.nutritionix.com/v2/search/instant")!
        
        let bodyString = "query=\(query)"
        let bodyData = bodyString.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = bodyData
        return request
    }
    
    func performFoodRequest(request: URLRequest, completion: @escaping ([String?]) -> Void) {
        var fibreRequests: [String?] = []
        
        // Make sure request is not nil
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            // If data is received successfully
            if let safeData = data {
                
                // Parse JSON into a food names optional Strings
                fibreRequests = self.parseFoodJSON(foodData: safeData)
            }
            
            // Call the completion handler with fibreRequests ([String?])
            completion(fibreRequests)
        }
        
        // Start task
        task.resume()
    }
    
    func prepareFibreRequest(foodRequest: String?) -> URLRequest? {
        
        // If string is not nil
        if let query = foodRequest {
            
            // Prepare request; code from https://docx.syndigo.com/developers/docs/natural-language-for-nutrients
            let url = URL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients")!
            
            let bodyString = "query=\(query)"
            let bodyData = bodyString.data(using: .utf8)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = bodyData
            return request
        }
        return nil
    }
    
    func performFibreRequest(request: URLRequest?, completion: @escaping (Food?) -> Void) {
        var fibreFood: Food? = nil
        
        // Make sure request is not nil
        if let safeRequest = request {
            
            // Create a data task with the given request
            let task = URLSession.shared.dataTask(with: safeRequest) { (data, response, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                
                // If data is received successfully
                if let safeData = data {
                    
                    // Parse JSON into a Food object
                    if let food = self.parseFibreJSON(fibreData: safeData) {
                        fibreFood = food
                    }
                }
                // Call the completion handler with fibreFood (Food or nil)
                completion(fibreFood)
                
            }
            
            // Start task
            task.resume()
        }
    
    }
    
    
    func parseFoodJSON(foodData: Data) -> [String?] {
        var foodList: [String?] = []
        let decoder = JSONDecoder()
        
        // Try to decode data from Nutritionix API
        do {
            let decodedData = try decoder.decode(FoodData.self, from: foodData)
            
            // Append food names to a foodList
            for food in decodedData.common {
                foodList.append(food.food_name)
            }
            for food in decodedData.branded {
                foodList.append(food.food_name)
            }
        } catch {
            print("error") // need to change
        }
        return foodList
        
    }

    // only unbranded? need to address
    func parseFibreJSON(fibreData: Data) -> Food? {
        let decoder = JSONDecoder()
        
        // Try to decode data from Nutritionix API
        do {
            let decodedData = try decoder.decode(FibreData.self, from: fibreData)
            
            // Create Food object from Nutrionix API JSON
            let food = decodedData.foods[0]
            let foodName = food.food_name
            let brandName = food.brand_name ?? "unbranded"
            let consumptionTime = food.consumed_at
            let servingFibre = food.nf_dietary_fiber
            let servingUnit = food.serving_unit
            let servingQuantity = food.serving_qty
            let servingGrams = food.serving_weight_grams

            let servingExpression = "\(servingQuantity) \(servingUnit)"
            let servingMeasure = Measure(measureExpression: servingExpression, measureMass: servingGrams)
            
            let fibrePerGram = servingFibre/servingGrams
            var altMeasures: [Measure] = []
            
            // Create Measure objects from Nutrionix API JSON
            for altMeasure in food.alt_measures {
                let measureMass = altMeasure.serving_weight
                let measure = altMeasure.measure
                let measureQuantity = altMeasure.qty
                let altMeasureExpression = "\(measureQuantity) \(measure)"
                let parsedMeasure = Measure(measureExpression: altMeasureExpression, measureMass: measureMass)
                altMeasures.append(parsedMeasure)
            }
            altMeasures.append(servingMeasure)
            
            let parsedFood = Food(food: foodName, fibrePerGram: fibrePerGram, brandName: brandName, measures: altMeasures, selectedMeasure: servingMeasure, multiplier: 1.0, consumptionTime: consumptionTime)
            return parsedFood
            
        } catch {
            print(error)
            return nil
        }
        
    }
}

