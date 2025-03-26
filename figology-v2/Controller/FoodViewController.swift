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
    
    @IBOutlet weak var tableView: UITableView!
    
    let fibreCallManager = FibreCallManager()
    var fibreRequests: [URLRequest?] = []
    var parsedFoods: [Food?] = []
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.foodCellIdentifier, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)

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
    
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedFoods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        let cellFood = parsedFoods[indexPath.row]
        cell.foodNameLabel.text = cellFood!.food
        let descriptionString = "\( cellFood!.brandName), \( cellFood!.multiplier) g"
        cell.foodDescriptionLabel.text = descriptionString
        cell.fibreMassLabel.text = "\(String(format: "%.1f", cellFood!.fibrePerGram*cellFood!.multiplier)) g"

        return cell
    }

}

extension FoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
