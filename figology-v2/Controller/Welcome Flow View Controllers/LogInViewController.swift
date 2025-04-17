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
    let errorManager = ErrorManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.logInPasswordSegue {
            let destinationVC = segue.destination as! PasswordViewController
            if let email = emailTextField.text
            {
                destinationVC.email = email
            }
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, err in
                if let err = err {
                    self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
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
                self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
            } else {
                if (result?.user) != nil {
                    let user = result?.user
                    let idToken = user?.idToken?.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: user!.accessToken.tokenString)
                    Auth.auth().signIn(with: credential) { result, err in
                        if let err = err {
                            self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                        } else {
                            if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                if isNewUser {
                                    let rawDate = Date()
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    let date = dateFormatter.string(from: rawDate)
                                    self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                                        date: [:]
                                    ]) { err in
                                        if let err = err {
                                            self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                                        } else {
                                            self.performSegue(withIdentifier: K.logInCalculatorSegue, sender: self)
                                        }
                                    }
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

