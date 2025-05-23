//
//  SignUpViewController.swift
//  
//
//  Created by olivia chen on 2025-03-07.
//

import UIKit
import GoogleSignIn
import Firebase


class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    let firebaseManager = FirebaseManager()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        // Code from https://firebase.google.com/docs/auth/ios/password-auth
        
        // If email and password are not nil
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            // Create new user using email and password. createUser has email and password validation
            Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
                
                // If there is an error, show error to user
                if let err = err {
                    
                    // Unless the "error" is the user cancelling the authentication
                    if err.localizedDescription != "The user canceled the sign-in flow." {
                        self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                    }
                    
                // Otherwise, perform segue to calculator
                } else {
                    self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                }
            }
        }
    }
    
    
    @IBAction func googleSignUpPressed(_ sender: GIDSignInButton) {
        
        // Code from https://firebase.google.com/docs/auth/ios/google-signin
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, err in
            
            // If there is an error, show error to user
            if let err = err {
                
                // Unless the "error" is the user cancelling the authentication
                if err.localizedDescription != "The user canceled the sign-in flow." {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                
            } else {
                if (result?.user) != nil {
                    let user = result?.user
                    let idToken = user?.idToken?.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                                   accessToken: user!.accessToken.tokenString)
                    
                    // Sign in user with Google
                    Auth.auth().signIn(with: credential) { result, err in
                        
                        // If there are errors in signing up, show error to user
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                            
                        }
                        
                        // Otherwise, check if user is new or not
                        else {
                            
                            if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                
                                // If user is new, go to calculator view controller
                                if isNewUser {
                                    self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                                }
                                
                                // If user is not new, go to tab bar view controller
                                else {
                                    self.performSegue(withIdentifier: K.signUpTabSegue, sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

