//
//  TabBarController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-18.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation button upon completing authentication
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

