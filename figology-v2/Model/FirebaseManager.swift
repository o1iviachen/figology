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
    
    func logFood(food: Food, meal: String, dateString: String) {
        let encoder = JSONEncoder()
        do {
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
                    dateString: [meal: FieldValue.arrayRemove([foodDictionary])]
                ]) { err in
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
    
    func fetchFoods(dateString: String, completion: @escaping ([[Food]]) -> Void) {
        var tableData: [[Food]] = [[],[],[],[]]
        let mealNames = ["breakfast", "lunch", "dinner", "snacks"]
        db.collection("users").document((Auth.auth().currentUser?.email)!).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
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
            if dateData != nil {
                // Clear the existing table data
                for meal in mealNames {
                    if let foods = dateData?[meal] as? [[String: Any]] {
                        for food in foods {
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
                            let foodObject = Food(
                                food: food["food"] as! String,
                                fibrePerGram: food["fibrePerGram"] as! Double, brandName: food["brandName"] as! String,
                                measures: measurements,
                                selectedMeasure: food["selectedMeasure"] as! Measure,
                                multiplier: food["multiplier"] as! Double
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
    
    func removeFood(food: Food, meal: String, dateString: String) {
        let encoder = JSONEncoder()
        do {
            let foodData = try encoder.encode(food)
            if let foodDictionary = try JSONSerialization.jsonObject(with: foodData, options: []) as? [String: Any] {
                print(foodDictionary)
                db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
                    dateString: [meal: FieldValue.arrayRemove([foodDictionary])]
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



