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
            "x-app-key": "7ecc612b2d7418187f2187710a7da088",
            "x-remote-user-id": "0"
    ]
    
    func prepareFoodRequest(foodSearch: String) -> URLRequest {
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
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            if let safeData = data {
                fibreRequests = self.parseFoodJSON(foodData: safeData)
            }
            
            // Call the completion handler with the results
            completion(fibreRequests)
        }
        
        task.resume()
    }
    
    func prepareFibreRequest(foodRequest: String?) -> URLRequest? {
        if let query = foodRequest {
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
        if let safeRequest = request {
            let task = URLSession.shared.dataTask(with: safeRequest) { (data, response, error) in
                if let e = error {
                    print(e.localizedDescription)
                }
                if let safeData = data {
                    print(String(data: safeData, encoding: .utf8))
                    if let food = self.parseFibreJSON(fibreData: safeData) {
                        fibreFood = food
                    }
                }
                completion(fibreFood)
                
            }
            task.resume()
        }
    
    }
    
    
    func parseFoodJSON(foodData: Data) -> [String?] {
        var foodList: [String?] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FoodData.self, from: foodData)
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

        
    func parseFibreJSON(fibreData: Data) -> Food? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FibreData.self, from: fibreData)
            let food = decodedData.foods[0]
            let foodName = food.food_name
            let brandName = food.brand_name ?? "Unbranded"
            let servingFibre = food.nf_dietary_fiber
            let servingUnit = food.serving_unit
            let servingQuantity = food.serving_qty
            let servingGrams = food.serving_weight_grams

            let servingExpression = "\(servingQuantity) \(servingUnit)"
            let servingMeasure = Measure(measureExpression: servingExpression, measureMass: servingGrams)
            
            let fibrePerGram = servingFibre/servingGrams
            var altMeasures: [Measure] = []
            for altMeasure in food.alt_measures {
                let measureMass = altMeasure.serving_weight
                let measure = altMeasure.measure
                let measureQuantity = altMeasure.qty
                let altMeasureExpression = "\(measureQuantity) \(measure)"
                let parsedMeasure = Measure(measureExpression: altMeasureExpression, measureMass: measureMass)
                altMeasures.append(parsedMeasure)
            }
            
            let parsedFood = Food(food: foodName, fibrePerGram: fibrePerGram, brandName: brandName, measures: altMeasures, selectedMeasure: servingMeasure, multiplier: servingGrams)
            return parsedFood
            
        } catch {
            print(error)
            return nil
        }
        
    }
    

    
    
    
}

