//
//  SignUpViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-07.
//

import UIKit
import GoogleSignIn
import Firebase


class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    let errorManager = ErrorManager()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
                if let err = err {
                    self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                } else {
                    let rawDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd_MM_yyyy"
                    let date = dateFormatter.string(from: rawDate)
                    self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                        
                        date: [:]
                    ]) { err in
                        if let err = err {
                            self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                        } else {
                            self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func googleSignUpPressed(_ sender: GIDSignInButton) {
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
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                                   accessToken: user!.accessToken.tokenString)
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
                                    if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                        if isNewUser {
                                            self.db.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                                                date: [:]
                                            ]) { err in
                                                if let err = err {
                                                    self.errorManager.showError(errorMessage: err.localizedDescription, viewController: self)
                                                } else {
                                                    self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                                                }
                                            }
                                        }
                                    }
                                } else {
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

