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
    
    func performFoodRequest(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                if let safeData = data {
                    if let responseString = String(data: safeData, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    
                }
            }
            
            // start task
            task.resume()
        
    }
    
//    func parseJSON(foodData: Data) -> Food? {
//        var foodList: [Food] = []
//        let decoder = JSONDecoder()
//        // . self to data type
//        do {
//            let decodedData = try decoder.decode(Food.self, from: foodData)
//            let food = decodedData.common[0].food_name
//            let temp = decodedData.main.temp
//            let name = decodedData.name
//            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//            return weather
//        } catch {
//            return nil
//        }
//    }
    
    
    
}

