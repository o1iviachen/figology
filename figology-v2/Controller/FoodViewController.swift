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
    var fibreRequests: [URLRequest?] = []
    var parsedFoods: [Food?] = []
    override func viewDidLoad() {


        super.viewDidLoad()
        let request = fibreCallManager.prepareFoodRequest(foodSearch: "banana")
        // add, you can also add delegate for something else
        fibreCallManager.performFoodRequest(request: request) { results in
            for result in results {
                let request = self.fibreCallManager.prepareFibreRequest(foodRequest: result)
                self.fibreRequests.append(request)
            }
            for request in self.fibreRequests {
                self.fibreCallManager.performFibreRequest(request: request) { parsedFood in
                    self.parsedFoods.append(parsedFood)
                }
            }
        }
        
    }
    
    
    
    @IBAction func printFood(_ sender: UIButton) {
        print(parsedFoods)
    }
}
