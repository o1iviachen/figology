//
//  FirebaseManager.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import Foundation
import Firebase

// move getting the document
struct FirebaseManager {
    
    let db = Firestore.firestore()
    
    func formatDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy_MM_dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func logFood(food: Food, meal: String, dateString: String, fibreIntake: Double, completion: @escaping (Bool) -> Void) {
        var changedIntake = fibreIntake
        
        // Add food's fibre to the user's daily fibre intake
        changedIntake += food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
        let encoder = JSONEncoder()
        do {
            
            // Encode food struct to transfer data to Firebase Firestore
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                
                // Add corresponding food dictionary and changed fibre intake to user's document in Firebase Firestore
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                    dateString: [meal: FieldValue.arrayUnion([foodDictionary]), "fibreIntake": changedIntake]
                ], merge: true) { err in
                    
                    // If no error in adding food, call completion handler with success (true)
                    if err == nil {
                        completion(true)
                    }
                    
                    // Otherwise, call completion handler with failure (false)
                    else {
                        completion(false)
                    }
                }
            }
            // If there are errors in encoding, call completion handler with failure (false)
        } catch {
            completion(false)
        }
    }
    
    func fetchFoods(dateString: String, completion: @escaping ([[Food]]) -> Void) {
        var tableData: [[Food]] = [[],[],[],[]]
        let mealNames = ["breakfast", "lunch", "dinner", "snacks"]
        
        // Fetch Firebase Firestore document for user
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If there are errors in fetching document, call completion with empty table data
            guard let document = document else {
                print("Error fetching document: \(error!)") // errormanger?
                completion(tableData)
                return
            }
            
            // If the document is empty, call completion with empty table data
            guard document.data() != nil else {
                print("Document was empty.")
                completion(tableData)
                return
            }
            
            // Decode document data into dictionary
            let dateData = document.data()?[dateString] as? [String: Any]
            
            // Check if data is not nil
            if let safeData = dateData {
                
                // Loop through the meals
                for meal in mealNames {
                    
                    // Unwrap data in each meal to ensure foods are not nil and downcast to array of dictionaries
                    if let foods = safeData[meal] as? [[String: Any]] {
                        
                        // Loop through the logged foods in each meal
                        for food in foods {
                            var measurements: [Measure] = []
                            
                            // Unwrap data in each food to ensure measures are not nil and downcast to array of dictionaries
                            if let retrievedMeasures = food["measures"] as? [[String: Any]] {
                                
                                // Loop through corresponding measures of the food
                                for measurement in retrievedMeasures {
                                    
                                    // Create Measure object using Firebase Firestore data
                                    let measureExpression = measurement["measureExpression"] as! String
                                    let measureMass = measurement["measureMass"] as! Double
                                    let measureObject = Measure(measureExpression: measureExpression, measureMass: measureMass)
                                    measurements.append(measureObject)
                                }
                            }
                            
                            // Create selected measure dictionary by forced downcast since measure must be selected for food to be logged
                            let selectedMeasure = food["selectedMeasure"] as! [String: Any]
                            
                            // Create food object
                            let foodObject = Food(
                                food: food["food"] as! String,
                                fibrePerGram: food["fibrePerGram"] as! Double, brandName: food["brandName"] as! String,
                                measures: measurements,
                                selectedMeasure: Measure(measureExpression: selectedMeasure["measureExpression"] as! String, measureMass: selectedMeasure["measureMass"] as! Double),
                                multiplier: 1.0, consumptionTime: food["consumptionTime"] as! String
                            )
                            
                            // Append food object to table data
                            tableData[mealNames.firstIndex(of: meal)!].append(foodObject)
                        }
                    }
                }
            }
            
            // Call completion handler once all data is fetched
            completion(tableData)
        }
    }
    
    
    func removeFood(food: Food, meal: String, dateString: String, fibreIntake: Double, completion: @escaping (Bool) -> Void) {
        var changedIntake = fibreIntake
        
        // Subtract food's fibre to user's daily fibre intake
        changedIntake -= food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
        
        // Encode food struct to remove data to Firebase Firestore
        let encoder = JSONEncoder()
        do {
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                
                // Remove corresponding food dictionary and change user's fibre intake in Firebase Firestore
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                    dateString: [meal: FieldValue.arrayRemove([foodDictionary]), "fibreIntake": changedIntake]
                ], merge: true) { err in
                    
                    // If no error in removing food, call completion handler with success (true)
                    if err == nil {
                        completion(true)
                    } else {
                        
                        // Otherwise, call completion handler with failure (false)
                        completion(false)
                    }
                }
                
            }
        } catch {
            
            // If there are errors in encoding, call completion handler with failure (false)
            completion(false)
        }
        
    }
    
    func fetchFibreGoal(completion: @escaping (Int?) -> Void) {
        var fibreGoal: Int? = nil
        
        // Fetch Firebase Firestore document for user
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If there are errors in fetching document, call completion handler with no fibre goal (nil)
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(fibreGoal)
                return
            }
            
            // If the document is empty, call completion handler with no fibre goal (nil)
            guard document.data() != nil else {
                print("Document was empty.")
                completion(fibreGoal)
                return
            }
            
            // Otherwise, get fibre goal, which may be nil.
            fibreGoal = document.data()?["fibreGoal"] as? Int
            
            // Call completion handler with fibre goal (Int or nil)
            completion(fibreGoal)
        }
        
    }
    
    func fetchFibreIntake(dateString: String, completion: @escaping (Double) -> Void) {
        var fibreIntake: Double = 0.0
        
        // Fetch Firebase Firestore document for user
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If there are errors in fetching document, call completion handler with no fibre intake (nil)
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(fibreIntake)
                return
            }
            
            // If the document is empty, call completion handler with no fibre intake (nil)
            guard document.data() != nil else {
                print("Document was empty.")
                completion(fibreIntake)
                return
            }
            
            // Otherwise, unwrap document data for the requested date and optional downcase to dictionary
            if let currentDate = document.data()?[dateString] as? [String: Any] {
                
                // If fibre intake exists, assign it to fibreIntake with two decimal places
                if let currentFibreIntake = currentDate["fibreIntake"] {
                    fibreIntake = ((currentFibreIntake as! Double)*10).rounded() / 10
                }
            }
            
            // Call completion handler with fibre intake (Double or nil)
            completion(fibreIntake)
        }
        
    }
    
    func fetchRecentFoods(completion: @escaping ([Food]) -> Void) {
        var recentData: [Food] = []
        
        // Fetch Firebase Firestore document for user
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If there are errors in fetching document, call completion handler with no recent data (nil)
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(recentData)
                return
            }
            
            guard document.data() != nil else {
                print("Document was empty.")
                completion(recentData)
                return
            }
            
            // Decode document data into array of dictionary
            let dateData = document.data()?["recentFoods"] as? [[String: Any]]
            
            // Check if data is not nil
            if let safeData = dateData {
                
                // Loop through the logged foods in each meal
                for food in safeData {
                    var measurements: [Measure] = []
                    
                    // Unwrap data in each food to ensure measures are not nil and downcast to array of dictionaries
                    if let retrievedMeasures = food["measures"] as? [[String: Any]] {
                        
                        // Loop through corresponding measures of the food
                        for measurement in retrievedMeasures {
                            
                            // Create Measure object using Firebase Firestore data
                            let measureExpression = measurement["measureExpression"] as! String
                            let measureMass = measurement["measureMass"] as! Double
                            let measureObject = Measure(measureExpression: measureExpression, measureMass: measureMass)
                            measurements.append(measureObject)
                        }
                    }
                    
                    // Create selected measure dictionary by forced downcast since measure must be selected for food to be logged
                    let selectedMeasure = food["selectedMeasure"] as! [String: Any]
                    
                    // Create food object
                    let foodObject = Food(
                        food: food["food"] as! String,
                        fibrePerGram: food["fibrePerGram"] as! Double, brandName: food["brandName"] as! String,
                        measures: measurements,
                        selectedMeasure: Measure(measureExpression: selectedMeasure["measureExpression"] as! String, measureMass: selectedMeasure["measureMass"] as! Double),
                        multiplier: 1.0, consumptionTime: food["consumptionTime"] as! String
                    )
                    
                    // Append food object to recent data
                    recentData.append(foodObject)
                }
            }
            // Call completion handler once all data is fetched
            completion(recentData)
        }
    }
    
    func addToRecentFoods(food: Food) {
        // Fetch Firebase Firestore document for user
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If there are errors in fetching document, call completion handler with no recent data (nil)
            guard let document = document else {
                print("Error fetching document: \(error!)")
                return
            }
            
            // If the document is empty, call completion handler with no recent data (nil)
            guard document.data() != nil else {
                print("Document was empty.")
                return
            }
            
            // Decode document data into array of dictionary
            if let recentFoods = document.data()?["recentFoods"] as? [[String: Any]] {
                
                // If there are 10 or more recent foods, remove the earliest one added
                if recentFoods.count >= 10 {
                    let formatter = ISO8601DateFormatter()
                    var dates: [String] = []
                    
                    // Determine all the times the foods were added
                    for food in recentFoods {
                        if let date = formatter.date(from: food["consumptionTime"] as! String) {
                            let isoString = formatter.string(from: date)
                            dates.append(isoString)
                        }
                    }
                    
                    // Determine the earliest added food
                    if let earliest = dates.min() {
                        
                        // Retrieve index of earliest food
                        let minIndex = dates.firstIndex(of: earliest)!
                        let foodDictToDelete = recentFoods[minIndex]
                        
                        // Remove earliest food
                        db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                            "recentFoods": FieldValue.arrayRemove([foodDictToDelete])
                        ], merge: true, completion: nil)
                        
                    }
                }
            }
            
            let encoder = JSONEncoder()
            do {
                
                // Encode food struct to transfer data to Firebase Firestore
                let foodData = try encoder.encode(food)
                if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                    
                    // Add corresponding food dictionary to user's document in Firebase Firestore
                    db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                        "recentFoods": FieldValue.arrayUnion([foodDictionary])], merge: true, completion: nil)
                }
            } catch { // not too sure
                print("Error encoding food object: \(error)")
            }
            
        }
    }
}



