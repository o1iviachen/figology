//
//  FoodViewController.swift
//  figology-v2
//
//  Created by su huang on 2025-03-05.
//

import Foundation
import UIKit
import Firebase

class FoodViewController: UIViewController {
    
    let fibreCallManager = FibreCallManager()
    override func viewDidLoad() {


        super.viewDidLoad()
        var request = fibreCallManager.prepareFoodRequest(foodSearch: "banana")
        fibreCallManager.performFoodRequest(request: request)
    }
}
