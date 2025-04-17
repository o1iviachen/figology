//
//  LogInViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//

import UIKit
import GoogleSignIn
import Firebase


class LogInViewController: UIViewController {
    
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If segue that will be performed goes to password view controller
        if segue.identifier == K.logInPasswordSegue {
            
            // Force downcast destinationVC as PasswordViewController
            let destinationVC = segue.destination as! PasswordViewController
            
            // Set PasswordViewController class attribute as email
            if let email = emailTextField.text {
                destinationVC.email = email
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Get email and password
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            // Sign in user using email and password. signIn has email and password validation
            Auth.auth().signIn(withEmail: email, password: password) { authResult, err in
                
                // If there is an error, show error to user in popup
                if let err = err {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                    
                    // Otherwise, perform segue to tab bar view controller
                } else {
                    self.performSegue(withIdentifier: K.logInTabSegue, sender: self)
                }
            }
        }
    }
    
    @IBAction func googleLogInPressed(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, err in
            if let err = err {
                self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
            } else {
                if (result?.user) != nil {
                    let user = result?.user
                    let idToken = user?.idToken?.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: user!.accessToken.tokenString)
                    
                    // Sign in user with Google
                    Auth.auth().signIn(with: credential) { result, err in
                        
                        // If there are errors in signing in, show error to user in popup
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                        
                        // Otherwise, check if user is new or not
                        } else {
                            
                            // If user is new, go to calculator view controller
                            if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                if isNewUser {
                                    
                                    self.performSegue(withIdentifier: K.logInCalculatorSegue, sender: self)
                                    
                                // If user is not new, go to tab bar view controller
                                } else {
                                    self.performSegue(withIdentifier: K.logInTabSegue, sender: self)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

