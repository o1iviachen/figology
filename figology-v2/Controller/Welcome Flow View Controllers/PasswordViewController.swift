//
//  PasswordViewController.swift
//  figology-v2
//
//  Created by emily zhang on 2025-03-17.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {
    override func viewDidLoad() {
        if email != "" {
            emailTextField.text = email
        }
    }
    
    var email = ""
    let errorManager = ErrorManager()


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func sendEmailPressed(_ sender: UIButton) {
        let emailAddress = emailTextField.text
        Auth.auth().sendPasswordReset(withEmail: emailAddress ?? "") { err in
            if let err = err {
                self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
            } else {
                Auth.auth().fetchSignInMethods(forEmail: emailAddress ?? "", completion: {
                    (signInMethods, err) in
                    
                    if let err = err {
                        self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                    } else {
                        let alert = UIAlertController(title: "Completed!", message: "Please check your email to reset your password.", preferredStyle: .alert)
                        
                        // Add an UIAlertAction with a handler to perform the segue
                        let gotItAction = UIAlertAction(title: "Got It!", style: .default) { (action) in
                            // Perform the segue when the "Got It!" button is tapped
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                        alert.addAction(gotItAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                                               
                )
                
                
            }
            
        }
    }
    
}
