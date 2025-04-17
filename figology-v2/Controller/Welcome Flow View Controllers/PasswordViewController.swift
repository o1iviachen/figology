//
//  PasswordViewController.swift
//  figology-v2
//
//  Created by emily zhang on 2025-03-17.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {
    var email: String? = ""
    let alertManager = AlertManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set email text field with email
        emailTextField.text = email
    }
    
    @IBAction func sendEmailPressed(_ sender: UIButton) {
        
        // Unwrap email
        if let email = emailTextField.text {
            
            // Send password resent if email is not nil. sendPasswordResent has email validation.
            Auth.auth().sendPasswordReset(withEmail: email) { err in
                
                // If there is an error, show error to user using popup
                if let err = err {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                
                // Otherwise, fetch sign in methods to use to reset password
                else {
                    Auth.auth().fetchSignInMethods(forEmail: email, completion: {
                        (signInMethods, err) in
                        
                        // If there is a fetch error, show error ot user using popup
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                        }
                        
                        // Otherwise, indicate user to check their email
                        else {
                            let alert = UIAlertController(title: "completed!", message: "please check your email to reset your password.", preferredStyle: .alert)
                            
                            // Add action to communicate understanding
                            let gotItAction = UIAlertAction(title: "got it!", style: .default) { (action) in
                                
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
}
