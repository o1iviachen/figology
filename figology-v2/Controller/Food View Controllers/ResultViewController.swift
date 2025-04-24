//
//  ResultViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase

class ResultViewController: UIViewController {
    var rawPickerOptions: [Any] = []
    var measureQuantity = 0.0
    var fibreMass = 0.0
    var measureList: [Measure] = []
    var selectedFood: Food? = nil
    var temporaryMeasure: Measure? = nil
    var fibreIntake: Double = 0.0
    var measureDescriptionList: [String] = []
    let firebaseManager = FirebaseManager()
    let db = Firestore.firestore()
    var dateString: String? = nil
    var originalMeal: String = "breakfast"
    var fibreGoal: Int? = nil
    let alertManager = AlertManager()
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var fibreLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var servingMeasureButton: UIButton!
    @IBOutlet weak var mealButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the delegrate of the text field to manage user interaction
        servingTextField.delegate = self
        
        // Initially configure UI with unmodified Food
        mealButton.setTitle(originalMeal, for: .normal)
        servingTextField.text = String(selectedFood!.multiplier)
        
        // Set temporary measure (keep selected food unchanged in case user is updating)
        temporaryMeasure = selectedFood!.selectedMeasure
        if dateString == nil {
            dateString = firebaseManager.formatDate()
        }
        // Fetch user document
        firebaseManager.fetchUserDocument { document in
            
            // Fetch fibre goal
            self.firebaseManager.fetchFibreGoal(document: document) { fetchedGoal in
                if let setFibreGoal = fetchedGoal {
                    self.fibreGoal = setFibreGoal
                }
            }
            
            // Fetch fibre intake
            self.firebaseManager.fetchFibreIntake(dateString: self.dateString!, document: document) { intake in
                self.fibreIntake = intake
            }
            self.updateUI()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
    }

    func updateUI() {
        
        // Calculate fibre in consumed food
        let calculatedFibre = selectedFood!.fibrePerGram*temporaryMeasure!.measureMass*selectedFood!.multiplier
        
        // Update UI with selected food's attributes
        foodLabel.text = selectedFood!.food
        fibreLabel.text = "\(String(format: "%.1f", calculatedFibre)) g"
        descriptionLabel.text = "\(selectedFood!.brandName), \(String(format: "%.1f", temporaryMeasure!.measureMass*selectedFood!.multiplier)) g"
        
        // Truncate text button if measure expression length is greater than 9
        if temporaryMeasure!.measureExpression.count < 10 {
            servingMeasureButton.setTitle(temporaryMeasure!.measureExpression, for: .normal)
        } else {
            servingMeasureButton.setTitle("\(String(temporaryMeasure!.measureExpression.prefix(9)))...", for: .normal)
        }
        
        // If fibre goal is not nil, calculate the percent of the daily goal the food accounts for
        if let safeFibreGoal = fibreGoal {
            let progressPercent = calculatedFibre/Double(safeFibreGoal)
            progressLabel.text = "this is \(Int(progressPercent*100))% of your fibre goal!"
            progressBar.progress = Float(progressPercent)
            progressBar.isHidden = false
        }
        
        // Otherwise, tell user to set their fibre goal
        else {
            progressLabel.text = "please set your fibre goal."
            progressBar.isHidden = true
        }
    }
    
    @objc func handleSwipe() {
        selectedFood!.multiplier = Double(servingTextField.text!)!
        updateUI()
        servingTextField.resignFirstResponder()
    }
    
    @objc func handleTap() {
        selectedFood!.multiplier = Double(servingTextField.text!)!
        updateUI()
        servingTextField.resignFirstResponder()
    }
    
    @IBAction func mealButtonSelected(_ sender: UIButton) {
        rawPickerOptions = ["breakfast", "lunch", "dinner", "snacks"]
        performSegue(withIdentifier: K.resultPickerSegue, sender: self)
    }
    
    @IBAction func servingButtonSelected(_ sender: UIButton) {
        rawPickerOptions = selectedFood!.measures
        performSegue(withIdentifier: K.resultPickerSegue, sender: self)
        
    }
    
    
    @IBAction func addFood(_ sender: UIBarButtonItem) {
        
        // If previous view controller is a FoodViewController, the user was updating their food
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2]
            if viewController is FoodViewController {
                
                // Therefore, remove the original selected food
                firebaseManager.removeFood(food: selectedFood!, meal: originalMeal, dateString: dateString!, fibreIntake: fibreIntake) { foodRemoved in
                    print(self.fibreIntake)
                    // Communicate error to user using a popup
                    if !foodRemoved {
                        self.alertManager.showAlert(alertMessage: "could not remove previous food.", viewController: self)
                    }
                }
            }
        }
        
        // Modify selected food to new values
        self.selectedFood!.multiplier = Double(self.servingTextField.text!)!
        self.selectedFood!.selectedMeasure = self.temporaryMeasure!
        
        // Fetch user document
        firebaseManager.fetchUserDocument { document in
            // Add new modified food to recent foods array
            self.firebaseManager.addToRecentFoods(food: self.selectedFood!, document: document)
            
            // Fetch fibre intake
            self.firebaseManager.fetchFibreIntake(dateString: self.dateString!, document: document) { intake in
                self.fibreIntake = intake

                // Log new modified food
                self.firebaseManager.logFood(food: self.selectedFood!, meal: self.mealButton.currentTitle!, dateString: self.dateString!, fibreIntake: self.fibreIntake) { foodAdded in
                    
                    // Communicate error to user using a popup
                    if !foodAdded {
                        self.alertManager.showAlert(alertMessage: "could not add new food.", viewController: self)
                    }
                }

            }
            
            
        }
                
        // Provide buffer time for Firebase Firestore to update so that UI adjusts accordingly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.resultPickerSegue {
            let destinationVC = segue.destination as! PickerViewController
            destinationVC.delegate = self
            destinationVC.options = rawPickerOptions
            
        }
    }
    
}

//MARK: - PickerViewControllerDelegate
extension ResultViewController: PickerViewControllerDelegate {
    func didSelectValue(value: Any) {
        
        // If the value is a string, it is a meal title
        if value is String {
            
            // Therefore, change the meal button text
            mealButton.setTitle(value as? String, for: .normal)
        }
        
        // Otherwise, it is a Measure
        else {
            
            // Hold new selected measure as temporary measure, to keep selected food the same
            temporaryMeasure = value as? Measure
        }
        updateUI()
    }
}

//MARK: - UITextFieldDelegate
extension ResultViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // If serving text field is empty when user tries to stop editing, write 1 as placeholder value
        if textField.text != "" {
            return true
        } else {
            textField.text = "1"
            return false
        }
        
    }
}

