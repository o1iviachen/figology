//
//  SceneDelegate.swift
//  
//
//  Created by olivia chen on 2025-02-25.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            // Instantiate Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Determine if there if a user logged in; code from https://stackoverflow.com/questions/37873608/how-do-i-detect-if-a-user-is-already-logged-in-firebase
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                
                // If a user is logged in, go to tab bar view controller
                if user != nil {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: K.tabBarIdentifier)
                    window.rootViewController = initialViewController
                }
                
                // If no user is logged in, go to welcome view controller
                else {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: K.welcomeIdentifier)
                    window.rootViewController = initialViewController
                }
            }
            
            
            window.makeKeyAndVisible()
            guard let _ = (scene as? UIWindowScene) else { return }
        }
    }
}

