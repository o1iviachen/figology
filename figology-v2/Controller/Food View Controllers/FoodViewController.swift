//
//  FoodViewController.swift
//  figology-v2
//
//  Created by su huang on 2025-03-05.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

class FoodViewController: UIViewController {
    
    var dateString: String? = nil
    let fibreCallManager = FibreCallManager()
    var fibreRequests: [URLRequest?] = []
    var fibreGoal: Int? = nil
    var tableData: [[Food]] = []
    let headerTitles = ["breakfast", "lunch", "dinner", "snacks"]
    let firebaseManager = FirebaseManager()
    var fibreIntake = 0.0
    var selectedFood: Food? = nil
    var selectedMeal: String? = nil
    let alertManager = AlertManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the delegate of the table view to handle user interactions
        tableView.delegate = self

        // Set the view controller as the data source of the table view to provide the data
        tableView.dataSource = self

        // Register food cell in table view
        tableView.register(UINib(nibName: K.foodCellIdentifier, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
        
        // Start with progress bar hidden
        progressBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get current date
        dateString = firebaseManager.formatDate()
        
        // Fetch user document in Firebase Firestore
        firebaseManager.fetchUserDocument { document in
            
            // Fetch current date's consumed foods
            self.firebaseManager.fetchFoods(dateString: self.dateString!, document: document) { data in
                self.tableData = data
                self.tableView.reloadData()
                print(self.tableData)
            }
            
            // Fetch current date's current fibre intake
            self.firebaseManager.fetchFibreIntake(dateString: self.dateString!, document: document) { intake in
                self.fibreIntake = Double(intake)
            }
            
            // Fetch fibre goal
            self.firebaseManager.fetchFibreGoal(document: document) { goal in
                self.fibreGoal = goal
                self.updateProgressUI()
            }
        }
        
        // Change the table view height depending on the number of foods
        DispatchQueue.main.async {
            if CGFloat(62*self.tableData.count + 40) > CGFloat(UIScreen.main.bounds.size.height) {
                self.tableView.heightAnchor.constraint(equalToConstant: CGFloat(62*self.tableData.count + 40)).isActive = true
                self.tableView.reloadData()
            }
        }
    }
    
    func updateProgressUI() {
        
        // If fibre goal exists
        if let setFibreGoal = fibreGoal {
            
            // Update progress label
            self.progressLabel.text = "you have consumed \(self.fibreIntake) g out of your \(setFibreGoal) g fibre goal! way to go."
            
            // Show decimal progress on progress bar
            self.progressBar.progress = Float(self.fibreIntake/Double(setFibreGoal))
            self.progressBar.isHidden = false
        } else {
            
            // Communicate to user to set their fibre goal
            self.progressLabel.text = "please set your fibre goal."
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If the segue to be performed goes to the result view controller (the food is being edited)
        if segue.identifier == K.foodResultSegue {
            let destinationVC = segue.destination as! ResultViewController
            
            // Prepare the result view controller's attributes
            destinationVC.selectedFood = selectedFood!
            destinationVC.originalMeal = selectedMeal!
        }
    }
    
    
}

//MARK: - UITableViewDataSource
extension FoodViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Required to populate the correct number of sections (number of meal types)
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Required to populate the correct number of foods per meal
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        
        // Get the required Food object
        let cellFood = tableData[indexPath.section][indexPath.row]
        
        // Access a food cell's attributes to customise the cells according to Food object
        cell.foodNameLabel.text = cellFood.food
        
        // Calculate the consumed mass
        let descriptionString = "\(cellFood.brandName), \(String(format: "%.1f", cellFood.multiplier*cellFood.selectedMeasure.measureMass)) g"
        cell.foodDescriptionLabel.text = descriptionString
        
        // Calculate the fibre mass per consumed mass
        cell.fibreMassLabel.text = "\(String(format: "%.1f", cellFood.fibrePerGram*cellFood.multiplier*cellFood.selectedMeasure.measureMass)) g"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // As long as there are more header titles, name sections
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
}

//MARK: - UITableViewDelegate
extension FoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if UIHostingController is in navigation stack
        let exists = navigationController?.viewControllers.contains {
            $0 is UIHostingController<AnyView>
        } == true
        
        // If not, user is not checking the food view controller from the calendar view controller. Therefore, allow user to edit food
        if !exists {
            selectedMeal = headerTitles[indexPath.section]
            selectedFood = tableData[indexPath.section][indexPath.row]
            performSegue(withIdentifier: K.foodResultSegue, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Makes editing style delete upon swiping left; code from https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell
        if editingStyle == .delete {
            
            // Get the food to delete
            selectedFood = tableData[indexPath.section][indexPath.row]
            
            // Delete food from Firebase Firestore
            firebaseManager.removeFood(food: selectedFood!, meal: headerTitles[indexPath.section], dateString: dateString!, fibreIntake: fibreIntake) { foodRemoved in
                
                // If food is successfully removed
                if foodRemoved {
                    
                    // Remove food from the table data
                    self.tableData[indexPath.section].remove(at: indexPath.row)
                    
                    // Delete food from table view with fade animation (self.tableView.reloadData() would not have the fade)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    // Fetch user document
                    self.firebaseManager.fetchUserDocument { document in
                        
                        // Fetch fibre intake with food removal
                        self.firebaseManager.fetchFibreIntake(dateString: self.dateString!, document: document) { intake in
                            self.fibreIntake = intake
                            
                            // Upon completion, update progress UI
                            self.updateProgressUI()
                        }
                    }
                    
                // Otherwise, show error message to user using pop up
                } else {
                    self.alertManager.showAlert(alertMessage: "could not remove food.", viewController: self)
                }
            }
            
            
        }
    }
}

//MARK: - UIViewControllerRepresentable
struct FoodView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: FoodViewController, context: Context) {
        // ?
    }
    
    let date: Date
    
    func makeUIViewController(context: Context) -> FoodViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodViewController") as! FoodViewController
        vc.dateString = FirebaseManager().formatDate()
        
        return vc
    }
    
}
