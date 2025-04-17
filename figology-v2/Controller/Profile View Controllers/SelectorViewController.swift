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
    
    @IBAction func fibreChanged(_ sender: UISlider) {
        fibreLabel.text = "\(String(Int(sender.value))) g"
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        fibreAmount = Int(fibreSlider.value)
        
        // Save selected fibre amount to user document on Firebase Firestore
        db.collection("users").document((Auth.auth().currentUser?.email)!).setData([ "fibreGoal": fibreAmount], merge: true)
        showResult(fibreAmount: fibreAmount)
    }
    
    func showResult(fibreAmount: Int) {
        
        let alert = UIAlertController(title: "completed!", message: "your fibre goal is now \(fibreAmount) g. you can change this at any time on the profile page.", preferredStyle: .alert)
        
        // Add an UIAlertAction with a handler to return to profile view controller
        let gotItAction = UIAlertAction(title: "got it!", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(gotItAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}

