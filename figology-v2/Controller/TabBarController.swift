//
//  TabBarController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-18.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}

