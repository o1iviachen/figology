//
//  SelectorViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit
import Firebase

class SelectorViewController: UIViewController {
    @IBOutlet weak var fibreLabel: UILabel!
    @IBOutlet weak var fibreSlider: UISlider!
    var fibreAmount = 0
    
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    
    @IBAction func fibreChanged(_ sender: UISlider) {
        fibreLabel.text = "\(String(Int(sender.value))) g"
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        fibreAmount = Int(fibreSlider.value)
        
        // Save selected fibre amount to user document on Firebase Firestore
        db.collection("users").document((Auth.auth().currentUser?.email)!).setData([ "fibreGoal": fibreAmount], merge: true)
        alertManager.showAlert(alertMessage: "your fibre goal is now \(fibreAmount) g. you can change this at any time on the profile page", viewController: self)
    }
}

