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
        showResult(fibreAmount: fibreAmount)
        
    }
    
    func showResult(fibreAmount: Int) {
        let alert = UIAlertController(title: "Completed!", message: "Your fibre goal is now \(fibreAmount) g. You can change this at any time on the profile page.", preferredStyle: .alert)
        
        // Add an UIAlertAction with a handler to perform the segue
        let gotItAction = UIAlertAction(title: "Got It!", style: .default) { (action) in
            // Perform the segue when the "Got It!" button is tapped
                UserDefaults.standard.set(fibreAmount, forKey: "fibreGoal")
                self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData([ "fibreGoal": fibreAmount], merge: true)
                self.navigationController?.popViewController(animated: true)

        }
        alert.addAction(gotItAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}

