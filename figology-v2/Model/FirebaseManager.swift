//
//  FirebaseManager.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import Foundation
import Firebase

struct FirebaseManager {
    
    let db = Firestore.firestore()
    
    func formatDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy_MM_dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func logFood(food: Food, meal: String, dateString: String) {
        fetchFibreIntake(dateString: dateString) { currentIntake in
            var changedIntake = currentIntake
            changedIntake += food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
            // ugly
            let encoder = JSONEncoder()
            do {
                let foodData = try encoder.encode(food)
                if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                    db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                        dateString: [meal: FieldValue.arrayUnion([foodDictionary]), "fibreIntake": changedIntake]
                    ], merge: true) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            } catch {
                print("Error encoding food object: \(error)")
            }
        }
        
        
    }
    
    func fetchFoods(dateString: String, completion: @escaping ([[Food]]) -> Void) {
        var tableData: [[Food]] = [[],[],[],[]]
        let mealNames = ["breakfast", "lunch", "dinner", "snacks"]
        // do change
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(tableData)
                return
            }
            guard document.data() != nil else {
                print("Document was empty.")
                completion(tableData)
                return
            }
            
            let dateData = document.data()?[dateString] as? [String: Any]
            
            // Check if data is not nil
            if let safeData = dateData {
                // Clear the existing table data
                for meal in mealNames {
                    if let foods = safeData[meal] as? [[String: Any]] {
                        for food in foods {
                            print(foods)
                            var measurements: [Measure] = []
                            if let retrievedMeasures = food["measures"] as? [AnyObject] {
                                for measurement in retrievedMeasures {
                                    if let measureValue = measurement as? [String: Any] {
                                        let measureExpression = measureValue["measureExpression"] as! String
                                        let measureMass = measureValue["measureMass"] as! Double
                                        let measureObject = Measure(measureExpression: measureExpression, measureMass: measureMass)
                                        measurements.append(measureObject)
                                    }
                                }
                            }
                            let selectedMeasure = food["selectedMeasure"] as! [String: Any]
                            let foodObject = Food(
                                food: food["food"] as! String,
                                fibrePerGram: food["fibrePerGram"] as! Double, brandName: food["brandName"] as! String,
                                measures: measurements,
                                selectedMeasure: Measure(measureExpression: selectedMeasure["measureExpression"] as! String, measureMass: selectedMeasure["measureMass"] as! Double),
                                multiplier: 1.0
                            )
                            tableData[mealNames.firstIndex(of: meal)!].append(foodObject)
                        }
                    }
                }
            } else {
                print("No data found for \(dateString)")
            }
            completion(tableData)
        }
    }
    
    // arrayUnion() adds elements to an array but only elements not already present.
    
    
    func removeFood(food: Food, meal: String, dateString: String) {
        fetchFibreIntake(dateString: dateString) { currentIntake in
            var changedIntake = currentIntake
            changedIntake -= food.fibrePerGram*food.selectedMeasure.measureMass*food.multiplier
            let encoder = JSONEncoder()
            do {
                let foodData = try encoder.encode(food)
                if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                    db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
                        dateString: [meal: FieldValue.arrayRemove([foodDictionary]), "fibreIntake": changedIntake]
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                    }
                    
                }
            } catch {
                print("Error encoding food object: \(error)")
            }
        }
    }
    
    func fetchFibreGoal(completion: @escaping (Int?) -> Void) {
        var fibreGoal: Int? = nil
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(fibreGoal)
                return
            }
            guard document.data() != nil else {
                print("Document was empty.")
                completion(fibreGoal)
                return
            }
            fibreGoal = document.data()?["fibreGoal"] as? Int
            completion(fibreGoal)
        }
        
    }
    
    func fetchFibreIntake(dateString: String, completion: @escaping (Double) -> Void) {
        var fibreIntake: Double = 0.0
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(fibreIntake)
                return
            }
            guard document.data() != nil else {
                print("Document was empty.")
                completion(fibreIntake)
                return
            }
            if let currentDate = document.data()?[dateString] as? [String: Any] {
                if let currentFibreIntake = currentDate["fibreIntake"] {
                    fibreIntake = currentFibreIntake as! Double
                }
            }
            completion(fibreIntake)
        }
        
    }
    
}



