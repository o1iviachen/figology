/**
 TabBarController.swift
 figology-v2
 Emily, Olivia, and Su
 This file runs the tab bar
 History:
 Mar 18, 2025: File creation
*/

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation button upon completing authentication
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

