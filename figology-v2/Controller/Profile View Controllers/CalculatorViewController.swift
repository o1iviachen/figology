//
//  CalculatorViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//


import UIKit
import Firebase

class CalculatorViewController: UIViewController {
    
    let bmrValues: [Range<Float>: (multiplier: Float, label: String)] = [
        0.0..<0.2: (1.2, "Sedentary"),
        0.2..<0.4: (1.375, "Slightly Active"),
        0.4..<0.6: (1.55, "Moderately Active"),
        0.6..<0.8: (1.725, "Moderately Active"),
        0.8..<1.1: (1.9, "Very Active")
    ]
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBAction func ageChanged(_ sender: UISlider) {
        ageLabel.text = "\(String(format: "%.0f", sender.value)) years"
    }
    
    @IBAction func heightChanged(_ sender: UISlider) {
        heightLabel.text = "\(String(format: "%.2f", sender.value)) m"
    }
    
    @IBAction func weightChanged(_ sender: UISlider) {
        weightLabel.text = "\(Int(sender.value)) kg"
    }
    
    
    @IBAction func activityChanged(_ sender: UISlider) {
        for (range, (_, label)) in bmrValues {
            if range.contains(sender.value) {
                    activityLabel.text = label
                }
            }

    }
    
    
    @IBAction func calculateGoal(_ sender: UIButton) {
        let activity = activitySlider.value
        let height = heightSlider.value
        let weight = weightSlider.value
        let age = ageSlider.value
        let bmr = (10*weight+625*height-5*age-78)
        
        for (range, (multiplier, _)) in bmrValues {
            if range.contains(activity) {
                    let calculatedGoal = Int(multiplier*bmr)
                    showResult(fibreGoal: calculatedGoal)
                }
            }
       
    }
    
    func showResult(fibreGoal: Int) {
        let alert = UIAlertController(title: "Completed!", message: "Your fibre goal is now \(fibreGoal)g. You can change this at any time on the profile page.", preferredStyle: .alert)
        
        // Add an UIAlertAction with a handler to perform the segue
        let gotItAction = UIAlertAction(title: "Got It!", style: .default) { (action) in
            // Perform the segue when the "Got It!" button is tapped
            
            self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData(["fibre_goal": fibreGoal], merge: true)
            // UserDefaults.standard.set(fibreGoal, forKey: "fibreGoal")
            self.navigationController?.popViewController(animated: true)
            
            
        }
        alert.addAction(gotItAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}
