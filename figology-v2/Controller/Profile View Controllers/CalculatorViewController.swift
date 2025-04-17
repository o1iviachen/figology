//
//  CalculatorViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//


import UIKit
import Firebase

class CalculatorViewController: UIViewController {
    var backButtonShow: Bool = false
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the back button visibility based on backButtonShow
        navigationItem.hidesBackButton = !backButtonShow
    }
    
    let bmrValues: [Range<Float>: (multiplier: Float, label: String)] = [
        0.0..<0.2: (1.2, "sedentary"),
        0.2..<0.4: (1.375, "slightly active"),
        0.4..<0.8: (1.55, "moderately active"),
        0.6..<0.8: (1.725, "fairly active"),
        0.8..<1.1: (1.9, "very active")
    ]
    
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
            
            // If a range in the bmrValues dictionary includes the sender value, display corresponding expression
            if range.contains(sender.value) {
                activityLabel.text = label
            }
        }
    }
    
    
    @IBAction func calculateGoal(_ sender: UIButton) {
        
        // Get all values for calculation
        let activity = activitySlider.value
        let height = heightSlider.value
        let weight = weightSlider.value
        let age = ageSlider.value
        
        // Calculate BMR following https://www.calculator.net/bmr-calculator.html
        let bmr = (10*weight+625*height-5*age-78)
        
        // Multiple BMR by multiplier from bmrValues dictionary
        for (range, (multiplier, _)) in bmrValues {
            if range.contains(activity) {
                
                // Calculate fibre goal following https://macrofactorapp.com/does-fiber-have-calories/
                let baselineFibre = bmr/1000*14
                let calculatedGoal = Int(multiplier*baselineFibre)
                alertManager.showAlert(alertMessage: "your fibre goal is now \(calculatedGoal) g. you can change this at any time on the profile page", viewController: self)
                db.collection("users").document((Auth.auth().currentUser?.email)!).setData(["fibreGoal": calculatedGoal], merge: true)
                
                // Make sure there is two or more view controllers
                if let navController = navigationController, navController.viewControllers.count >= 2 {
                    let viewController = navController.viewControllers[navController.viewControllers.count - 2]
                    
                    // If the last view controller is a profile view controller, the use did not just sign up. Therefore, pop view controller to profile view controller
                    if viewController is ProfileViewController {
                        navigationController?.popViewController(animated: true)
                    } else {
                        
                        // Otherwise, go to tam bar controller as user is using the application for the first time
                        performSegue(withIdentifier: K.calculatorTabSegue, sender: self)
                    }
                }
                break
            }
        }
    }
}
