/**
 CalculatorViewController.swift
 figology-v2
 Emily, Olivia, and Su
 This file runs the fibre goal calculator
 History:
 Mar 26, 2025: File creation
 Apr 78 2025: Updated fibre goal calculations logic
*/


import UIKit
import Firebase

class CalculatorViewController: UIViewController {
    /**
     A class that allows the user to calculate their commended daily fibre goal based on some health information collected with sliders in the Calculator View Controller.
     
     - Properties:
        - heightSlider (Unwrapped UISlider): Allows the user to use a slider to select their height.
        - ageSlider (Unwrapped UISlider): Allows the user to use a slider to select their age.
        - activitySlider (Unwrapped UISlider): Allows the user to use a slider to indicate their activity level.
        - weightSlider (Unwrapped UISlider): Allows the user to use a slider to select htier weight.
        - heightLabel (Unwrapped UILabel): Displays the user's height.
        - weightLabel (Unwrapped UILabel): Displays the user's weight.
        - activityLabel (Unwrapped UILabel): Displays the user's activity.
        - ageLabel (Unwrapped UILabel): Displays the user's age.
     */
    
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    let firebaseManager = FirebaseManager()
    let bmrValues: [Range<Float>: (multiplier: Float, label: String)] = [
        0.0..<0.2: (1.2, "sedentary"),
        0.2..<0.4: (1.375, "slightly active"),
        0.4..<0.8: (1.55, "moderately active"),
        0.6..<0.8: (1.725, "fairly active"),
        0.8..<1.1: (1.9, "very active")
    ]
    var backButtonShow: Bool = false
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    override func viewDidLoad() {
        /**
         Called after the View Controller is loaded to update the navigation bar.
         */
        
        super.viewDidLoad()
        
        // Set the back button visibility based on backButtonShow
        navigationItem.hidesBackButton = !backButtonShow
    }
    
    
    @IBAction func ageChanged(_ sender: UISlider) {
        /**
         Updates the age label based on the user's slider input.
         
         - Parameters:
            - sender (UISlider): Indicates the user's age.
         */
        
        ageLabel.text = "\(String(format: "%.0f", sender.value)) years"
    }
    
    
    @IBAction func heightChanged(_ sender: UISlider) {
        /**
        Updates the height label based on the user's slider input.
         
         - Parameters:
            - sender (UISlider): Indicates the user's height.
         */
        
        heightLabel.text = "\(String(format: "%.2f", sender.value)) m"
    }
    
    
    @IBAction func weightChanged(_ sender: UISlider) {
        /**
         Updates the weight label based on the user's slider input.
         
         - Parameters:
            - sender (UISlider): Indicates the user's weight.
         */
        
        weightLabel.text = "\(Int(sender.value)) kg"
    }
    
    
    @IBAction func activityChanged(_ sender: UISlider) {
        /**
         Updates the activity label based on the user's slider input.
         
         - Parameters:
            - sender (UISlider): Indicates the user's activity level.
         */
        
        for (range, (_, label)) in bmrValues {
            
            // If a range in the bmrValues dictionary includes the sender value, display corresponding expression
            if range.contains(sender.value) {
                activityLabel.text = label
            }
        }
    }
    
    
    @IBAction func calculateGoal(_ sender: UIButton) {
        /**
         Calculates the user's daily fibre intake goal based on their provided health information, then saves their intake goal to Firebase Firestore.
         
         - Parameters:
            - sender (UIButton): Triggers the calculation to take place.
         */
        
        // Get all values for calculation
        let activity = activitySlider.value
        let height = heightSlider.value
        let weight = weightSlider.value
        let age = ageSlider.value
        
        // Calculate BMR following https://www.calculator.net/bmr-calculator.html
        let bmr = (10*weight+625*height-5*age-78)
        
        // Multiply BMR by multiplier from bmrValues dictionary
        for (range, (multiplier, _)) in bmrValues {
            if range.contains(activity) {
                
                // Calculate fibre goal following https://macrofactorapp.com/does-fiber-have-calories/
                let calculatedGoal = Int(bmr*multiplier/1000*14)
                
                // Save calculated fibre amount to user document on Firebase Firestore
                firebaseManager.setFibreGoal(fibreAmount: calculatedGoal)
                alertManager.showAlert(alertMessage: "your fibre goal is now \(calculatedGoal) g. you can change this at any time on the profile page", viewController: self) {
                    
                    // Make sure there is two or more view controllers and determine the type of last view controller; code from https://stackoverflow.com/questions/16608536/how-to-get-the-previous-viewcontroller-that-pushed-my-current-view
                    if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                        let viewController = navController.viewControllers[navController.viewControllers.count - 2]
                        
                        // If the last view controller is a profile view controller, the user did not just sign up. Therefore, pop view controller to profile view controller
                        if viewController is ProfileViewController {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        // Otherwise, go to tab bar controller as user is using the application for the first time
                        else {
                            self.performSegue(withIdentifier: K.calculatorTabSegue, sender: self)
                        }
                    }
                }
                break
            }
        }
    }
}
