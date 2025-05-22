//
//  SelectorViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit
import Firebase

class SelectorViewController: UIViewController {
    var fibreAmount = 0
    let db = Firestore.firestore()
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    
    @IBOutlet weak var fibreLabel: UILabel!
    @IBOutlet weak var fibreSlider: UISlider!
    
    
    @IBAction func fibreChanged(_ sender: UISlider) {
        fibreLabel.text = "\(Int(sender.value)) g"
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        fibreAmount = Int(fibreSlider.value)
        
        // Save selected fibre amount to user document on Firebase Firestore
        firebaseManager.setFibreGoal(fibreAmount: fibreAmount)
        alertManager.showAlert(alertMessage: "your fibre goal is now \(fibreAmount) g. you can change this at any time on the profile page", viewController: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

