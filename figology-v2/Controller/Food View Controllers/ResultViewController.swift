//
//  ResultViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase
import FLAnimatedImage

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
    let errorManager = ErrorManager()
    
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
        mealButton.setTitle(originalMeal, for: .normal)
        temporaryMeasure = selectedFood!.selectedMeasure
        if dateString == nil {
            dateString = firebaseManager.formatDate()
        }
        firebaseManager.fetchFibreIntake(dateString: dateString!) { intake in
            self.fibreIntake = intake
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        servingTextField.delegate = self
        servingMeasureButton.titleLabel?.numberOfLines = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebaseManager.fetchFibreGoal { fetchedGoal in
            if let setFibreGoal = fetchedGoal {
                self.fibreGoal = setFibreGoal
            }
            self.updateUI()
            
        }
    }
    
    func updateUI() {
        let calculatedFibre = selectedFood!.fibrePerGram*temporaryMeasure!.measureMass*selectedFood!.multiplier
        foodLabel.text = selectedFood!.food
        fibreLabel.text = "\(String(format: "%.1f", calculatedFibre)) g"
        descriptionLabel.text = "\(selectedFood!.brandName), \(String(format: "%.1f", temporaryMeasure!.measureMass*selectedFood!.multiplier)) g"
        servingTextField.text = String(selectedFood!.multiplier)
        if temporaryMeasure!.measureExpression.count < 10 {
            servingMeasureButton.setTitle(temporaryMeasure!.measureExpression, for: .normal)
        } else {
            
            servingMeasureButton.setTitle("\(String(temporaryMeasure!.measureExpression.prefix(9)))...", for: .normal)
            
        }
        if let safeFibreGoal = fibreGoal {
            let progressPercent = calculatedFibre/Double(safeFibreGoal)
            progressLabel.text = "this is \(Int(progressPercent*100))% of your fibre goal!"
            progressBar.progress = Float(progressPercent)
        } else {
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
        // addr
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
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2]
            if viewController is FoodViewController {
                firebaseManager.removeFood(food: selectedFood!, meal: originalMeal, dateString: dateString!, fibreIntake: fibreIntake) { foodRemoved in
                    if !foodRemoved {
                        self.errorManager.showError(errorMessage: "could not remove previous food.", viewController: self)
                    }
                }
            }
        }
        
        self.selectedFood!.multiplier = Double(self.servingTextField.text!)!
        self.selectedFood!.selectedMeasure = self.temporaryMeasure!
        firebaseManager.logFood(food: selectedFood!, meal: mealButton.currentTitle!, dateString: dateString!, fibreIntake: fibreIntake) { foodAdded in
            if !foodAdded {
                self.errorManager.showError(errorMessage: "could not add new food.", viewController: self)
            }
        }
        
        firebaseManager.addToRecentFoods(food: selectedFood!)
        // patchwork, will not work with slow wifi
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
        if value is String {
            mealButton.setTitle(value as? String, for: .normal) }
        else {
            // problem w delete
            temporaryMeasure = value as? Measure
        }
        updateUI()
    }
}

//MARK: - UITextFieldDelegate
extension ResultViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // textfield triggers --> pass reference
        if textField.text != "" {
            return true
        } else {
            textField.text = "1"
            return false
        }
        
    }
}

