/**
 SelectorViewController.swift
 figology
 Emily, Olivia, and Su
 This file runs the manual fibre goal selector
 History:
 Mar 26, 2025: File creation
*/

import UIKit
import Firebase

class SelectorViewController: UIViewController {
    /**
     A class that allows the user to select and set a daily fibre goal using a UI Slider in the Selector View Controller, saving this data to Firebase Firestore once the user confirms their input.
     
     - Properties:
        - fibreLabel (Unwrapped UILabel): Displays the user's fibre goal.
        - fibreSlider (Unwrapped UISlider): Allows the user to use a slider to set their daily fibre goal.
     */
    
    let db = Firestore.firestore()
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    var fibreAmount = 0

    @IBOutlet weak var fibreLabel: UILabel!
    @IBOutlet weak var fibreSlider: UISlider!
    
    
    @IBAction func fibreChanged(_ sender: UISlider) {
        /**
         Updates the text when the user adjusts their fibre goal.
         
         - Parameters:
            - sender (UISlider): Contains the updates fibre goal to be displayed.
         */
        
        fibreLabel.text = "\(Int(sender.value)) g"
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        /**
         Saves the updated fibre goal to the user's document in Firebase Firestone once the user confirms their input.
         
         - Parameters:
            - sender (UIButton): Triggers the confirmation and data storage flow.
         */
        
        fibreAmount = Int(fibreSlider.value)
        
        // Save selected fibre amount to user document on Firebase Firestore
        firebaseManager.setFibreGoal(fibreAmount: fibreAmount)
        alertManager.showAlert(alertMessage: "your fibre goal is now \(fibreAmount) g. you can change this at any time on the profile page", viewController: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

