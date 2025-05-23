/**
 AppDelegate.swift
 figology-v2
 Emily, Olivia, and Su
 This file configures Firebase related applications, the navigation UI, and the tab bar UI
 History:
 Feb 25, 2025: File creation
*/

import UIKit
import CoreData
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /**
     A default class that handles higher level application tasks with some modifications.
     */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /**
         Called after the application is launched to initialise Firebase and set up the overall UI for navigation and tab bars.
         
         - Parameters:
            - application (UIApplication): Represents the app object.
            - launchOptions (Dictionary): Indicates why the app was launched.
         
         - Returns: A Bool indicating if the app was launched successfully.
         */
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        let lightPurple = UIColor(red: 242/255, green: 225/255, blue: 246/255, alpha: 1)
        let darkPurple = UIColor(red: 81/255.0, green: 48/255.0, blue: 101/255.0, alpha: 1.0)
        let mediumPurple = UIColor(red: 152/255.0, green: 132/255.0, blue: 160/255.0, alpha: 1)

        // Create UINavigationBarAppearance object conforming to UI
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = lightPurple
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.shadowColor = .clear

        // Create UITabBarAppearance object conforming to UI
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = lightPurple
        tabBarAppearance.shadowColor = .clear
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = mediumPurple
        
        // Change navigation bar appearance to conforming UINavigationBarAppearance object
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = darkPurple

        // Change tab bar appearance to conforming UITabBarAppearance object
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = darkPurple
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        /**
         Allows Google Sign In to open URLs.
         
         - Parameters:
            - app (UIApplication): Represents the app object.
            - url (URL): Contains the URL to be opened.
            - options (Dictionary): Contains a set of URL handling options
         
         - Returns: A Bool indicating if the URL was successfully opened.
         */
        
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - UISceneSession Lifecycle

    // Pre-existing, default function
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

