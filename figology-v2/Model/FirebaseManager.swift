//
//  FirebaseManager.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import Foundation
import Firebase

struct FirebaseManager {
    /**
     A structure that manages the food logging with Firebase.
     */
    
    let db = Firestore.firestore()
    
    
    func fetchUserDocument(completion: @escaping (DocumentSnapshot?) -> Void) {
        /**
         Fetches a Firestone document authorized through the user's email.
         
         - Parameters:
            - completion (Optional DocumentSnapshot): Stores the Firestone information at the time of the call.
         */
        
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            
            // If an error occurs in fetching document, call completion handler with no document snapshot (nil); code from https://cloud.google.com/firestore/docs/manage-data/add-data
            guard let document = document else {
                completion(document)
                return
            }
            
            // If the document is empty, call completion handler with no document snapshot (nil)
            guard document.data() != nil else {
                completion(document)
                return
            }
            
            completion(document)
        }
    }
    
    
    func logFood(food: Food, meal: String, dateString: String, fibreIntake: Double, completion: @escaping (Bool) -> Void) {
        /**
         Logs the fibre from the user's food input to the user's daily fibre intake.
         
         - Parameters:
            - food (Food): Food object with identification, fibre, and consumption information.
            - meal (String): The meal during which the food was consumed.
            - dateString (String): The date (YYYY-MM-DD) the food was logged.
            - fibreIntake (Double): The current daily total fibre intake.
            - completion (Bool):  Indicates if the Firestore update was successful.
         */
        
        // Add food's fibre to the user's daily fibre intake; learned that arguments in Swift are immutable https://stackoverflow.com/questions/40268619/why-are-function-parameters-immutable-in-swift
        let changedIntake = fibreIntake + food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
        
        let encoder = JSONEncoder()
        do {
            
            // Encode Food object to log food to Firebase Firestore
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                
                // Add corresponding food dictionary and changed fibre intake to user's document in Firebase Firestore; code from https://cloud.google.com/firestore/docs/manage-data/add-data
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                    dateString: [meal: FieldValue.arrayUnion([foodDictionary]), "fibreIntake": changedIntake]
                ], merge: true) { err in
                    
                    // If no error occurs in logging food, call completion handler with success (true)
                    if err == nil {
                        completion(true)
                    }
                    
                    // Otherwise, call completion handler with failure (false)
                    else {
                        completion(false)
                    }
                }
            }
        }
        
        // If an error occurs in encoding, call completion handler with failure (false)
        catch {
            completion(false)
        }
    }
    
    
    func removeFood(food: Food, meal: String, dateString: String, fibreIntake: Double, completion: @escaping (Bool) -> Void) {
        /**
         Removes the food idem and associated fibre measurement from the user's log.
         
         - Parameters:
            - food (Food):
         */
        
        // Subtract food's fibre from user's daily fibre intake; learned that arguments in Swift are immutable https://stackoverflow.com/questions/40268619/why-are-function-parameters-immutable-in-swift
        let changedIntake = fibreIntake - food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
                
        let encoder = JSONEncoder()
        do {
            
            // Encode Food object to remove food from Firebase Firestore
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                
                // Remove corresponding food dictionary and add changed fibre intake to user's document in Firebase Firestore; code from https://cloud.google.com/firestore/docs/manage-data/add-data
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                    dateString: [meal: FieldValue.arrayRemove([foodDictionary]), "fibreIntake": changedIntake]
                ], merge: true) { err in
                    
                    // If no error occurs in removing food, call completion handler with success (true)
                    if err == nil {
                        completion(true)
                    }
                    
                    // Otherwise, call completion handler with failure (false)
                    else {
                        completion(false)
                    }
                }
            }
        }
        
        // If an error occurs in encoding, call completion handler with failure (false)
        catch {
            completion(false)
        }
    }
    
    
    func fetchRecentFoods(document: DocumentSnapshot?, completion: @escaping ([Food]) -> Void) {
        var recentData: [Food] = []
        
        // Unwrap document data recent foods and optional downcast to list of dictionaries
        if let safeData = document?.data()?["recentFoods"] as? [[String: Any]] {
            
            // Loop through the recent foods to create corresponding Food objects
            for food in safeData {
                let foodObject = parseFirebaseFood(food: food)
                
                // Append Food object to recent data list
                recentData.append(foodObject)
            }
            
            let dateManager = DateManager()
            
            // Sort the foods from latest to earliest using bubble sort
            for i in 0..<recentData.count - 1 {
                var swapped = false
                
                // Check each consumption time against next consumption time
                for j in 0..<recentData.count-i-1 {
                    
                    // If the current consumption time is earlier than the next consumption time, swap the two elements
                    if dateManager.formatString(dateString: recentData[j].consumptionTime!, stringFormat: "yy_MM_dd HH:mm:ss") < dateManager.formatString(dateString: recentData[j+1].consumptionTime!, stringFormat: "yy_MM_dd HH:mm:ss") {
                        swapped = true
                        recentData.swapAt(j, j+1)
                    }
                }
                
                // If nothing swaps after an iteration, the foods are already sorted
                if !swapped {
                    completion(recentData)
                }
            }
        }
        completion(recentData)
    }
    
    
    func addToRecentFoods(food: Food, recentFoods: [Food]) {
        let encoder = JSONEncoder()
        
        // Limit recent foods list to 10 foods
        if recentFoods.count == 10 {
            do {
                
                // Encode earliest Food object to remove food from Firebase Firestore; code from https://cloud.google.com/firestore/docs/manage-data/add-data
                let foodtoDeleteData = try encoder.encode(recentFoods[9])
                if let foodtoDeleteDictionary = try JSONSerialization.jsonObject(with: foodtoDeleteData, options: []) as? [String: Any] {
                    
                    // Remove corresponding food dictionary from recent foods in user's document in Firebase Firestore
                    db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                        "recentFoods": FieldValue.arrayRemove([foodtoDeleteDictionary])
                    ], merge: true, completion: nil)
                }
            } catch {}
        }
        
        do {
            
            // Encode Food object to add food to Firebase Firestore
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                
                // Add corresponding food dictionary to user's document in Firebase Firestore; code from https://cloud.google.com/firestore/docs/manage-data/add-data
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                    "recentFoods": FieldValue.arrayUnion([foodDictionary])], merge: true, completion: nil)
            }
        } catch {}
    }
    
    
    func fetchFoods(dateString: String, document: DocumentSnapshot?, completion: @escaping ([[Food]]) -> Void) {
        var tableData: [[Food]] = [[],[],[],[]]
        let mealNames = ["breakfast", "lunch", "dinner", "snacks"]
        
        // Unwrap document data for the requested date and optional downcast to dictionary
        if let safeData = document?.data()?[dateString] as? [String: Any] {
            for meal in mealNames {
                
                // Optional downcast each meal to array of dictionaries
                if let foods = safeData[meal] as? [[String: Any]] {
                    
                    // Loop through the logged foods in each meal to initialise Food objects
                    for food in foods {
                        let foodObject = parseFirebaseFood(food: food)
                        
                        // Append Food object to table data, index of nested array depends on meal
                        tableData[mealNames.firstIndex(of: meal)!].append(foodObject)
                    }
                }
            }
        }
        
        // Call completion handler once all data is fetched
        completion(tableData)
    }
    
    
    func fetchFibreIntake(dateString: String, document: DocumentSnapshot?, completion: @escaping (Double) -> Void) {
        var fibreIntake: Double = 0.0
        
        // Unwrap document data for the requested date and optional downcast to dictionary
        if let currentDate = document?.data()?[dateString] as? [String: Any] {
            
            // If fibre intake exists, assign it to fibreIntake with two decimal places
            if let currentFibreIntake = currentDate["fibreIntake"] {
                fibreIntake = ((currentFibreIntake as! Double)*10).rounded() / 10
            }
        }
        
        // Call completion handler possibly with fibre intake
        completion(fibreIntake)
    }
    
    func setFibreGoal(fibreAmount: Int) {
        db.collection("users").document((Auth.auth().currentUser?.email)!).setData([ "fibreGoal": fibreAmount], merge: true)
    }
    
    func fetchFibreGoal(document: DocumentSnapshot?, completion: @escaping (Int?) -> Void) {
        
        // Fetch fibre goal, which may be nil
        let fibreGoal = document?.data()?["fibreGoal"] as? Int
        
        // Call completion handler possibly with fibre goal
        completion(fibreGoal)
    }
    
    
    func parseFirebaseFood(food: [String: Any]) -> Food {
        var measurements: [Measure] = []
        
        // Force downcast the food's measures to array of dictionaries since a food must have measures
        let retrievedMeasures = food["measures"] as! [[String: Any]]
        for measurement in retrievedMeasures {
            
            // Create Measure object using Firebase Firestore data
            let measureExpression = measurement["measureExpression"] as! String
            let measureMass = measurement["measureMass"] as! Double
            let measureObject = Measure(measureExpression: measureExpression, measureMass: measureMass)
            measurements.append(measureObject)
        }
        
        // Create selected measure dictionary by forced downcast since measure must be selected for food to be logged
        let selectedMeasure = food["selectedMeasure"] as! [String: Any]
        
        // Create Food object
        let foodObject = Food(
            food: food["food"] as! String,
            fibrePerGram: food["fibrePerGram"] as! Double, brandName: food["brandName"] as! String,
            measures: measurements, selectedMeasure: Measure(measureExpression: selectedMeasure["measureExpression"] as! String, measureMass: selectedMeasure["measureMass"] as! Double), multiplier: food["multiplier"] as! Double, consumptionTime: food["consumptionTime"] as? String
        )
        
        return(foodObject)
    }
}
