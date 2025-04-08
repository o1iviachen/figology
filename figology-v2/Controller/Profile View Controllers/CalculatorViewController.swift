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
                let baselineFibre = bmr/1000*14
                    let calculatedGoal = Int(multiplier*baselineFibre)
                    showResult(fibreGoal: calculatedGoal)
                }
            }
       
    }
    
    func showResult(fibreGoal: Int) {
        let alert = UIAlertController(title: "Completed!", message: "Your fibre goal is now \(fibreGoal) g. You can change this at any time on the profile page.", preferredStyle: .alert)
        
        let gotItAction = UIAlertAction(title: "Got It!", style: .default) { (action) in
             
            self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData(["fibreGoal": fibreGoal], merge: true)
            if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                 let viewController = navController.viewControllers[navController.viewControllers.count - 2]
                if viewController is ProfileViewController {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.performSegue(withIdentifier: K.calculatorTabSegue, sender: self)
                }
            }
          
            
        }
        alert.addAction(gotItAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}
