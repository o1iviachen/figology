//
//  PasswordViewController.swift
//  
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
        
        // Set email text field text as email
        emailTextField.text = email
    }
    
    
    @IBAction func sendEmailPressed(_ sender: UIButton) {
        
        // Code from https://firebase.google.com/docs/auth/ios/manage-users
        
        // If email is not nil
        if let email = emailTextField.text {
            
            // Send password reset email if email is not nil. sendPasswordReset has email validation
            Auth.auth().sendPasswordReset(withEmail: email) { err in
                
                // If there is an error, show error to user
                if let err = err {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                
                // Otherwise, fetch sign in methods to use to reset password
                else {
                    Auth.auth().fetchSignInMethods(forEmail: email, completion: {
                        (signInMethods, err) in
                        
                        // If there is an error, show error to user
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                        }
                        
                        // Otherwise, notify user to check their email
                        else {
                            self.alertManager.showAlert(alertMessage: "please check your email to reset your password", viewController: self)
                        }
                    }
                    )
                }
            }
        }
    }
}
