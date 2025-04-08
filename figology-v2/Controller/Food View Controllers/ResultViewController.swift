//
//  ResultViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase
import FLAnimatedImage

class ResultViewController: UIViewController, UITextFieldDelegate {
    var rawPickerOptions: [Any] = []
    var measureQuantity = 0.0
    var fibreMass = 0.0
    var measureList: [Measure] = []
    var selectedFood: Food? = nil
    // Food(food: "hasbjda", fibrePerGram: 2.3, brandName: "sdf", measures: [Measure(measureExpression: "Sdf", measureMass: 213)], selectedMeasure: Measure(measureExpression: "Sdf", measureMass: 213), multiplier: 123)
    var measureDescriptionList: [String] = []
    let firebaseManager = FirebaseManager()
    let db = Firestore.firestore()
    var dateString: String? = nil
    var meal: String = "breakfast"
    var fibreGoal: Int? = nil
    
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
        if dateString == nil {
            dateString = firebaseManager.formatDate()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        servingTextField.delegate = self
        
        
        
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
        let calculatedFibre = selectedFood!.fibrePerGram*selectedFood!.selectedMeasure.measureMass*selectedFood!.multiplier
        foodLabel.text = selectedFood!.food
        fibreLabel.text = "\(String(format: "%.1f", calculatedFibre)) g"
        descriptionLabel.text = "\(selectedFood!.brandName), \(String(format: "%.1f", selectedFood!.selectedMeasure.measureMass*selectedFood!.multiplier)) g"
        servingTextField.text = String(selectedFood!.multiplier)
        mealButton.setTitle(meal, for: .normal)
        servingMeasureButton.setTitle(selectedFood!.selectedMeasure.measureExpression, for: .normal)
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // textfield triggers --> pass reference
        if textField.text != "" {
            return true
        } else {
            textField.text = "1"
            return false
        }
        
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
        if let lastViewController = navigationController!.viewControllers.last,
           lastViewController is FoodViewController {
            firebaseManager.removeFood(food: selectedFood!, meal: meal, dateString: dateString!)
            selectedFood!.multiplier = Double(servingTextField.text!)!
            firebaseManager.logFood(food: selectedFood!, meal: mealButton.currentTitle!, dateString: dateString!)
        } else {
            selectedFood!.multiplier = Double(servingTextField.text!)!
            firebaseManager.logFood(food: selectedFood!, meal: mealButton.currentTitle!, dateString: dateString!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.resultPickerSegue {
            let destinationVC = segue.destination as! PickerViewController
            destinationVC.delegate = self
            destinationVC.options = rawPickerOptions
            
        }
    }
    
}

extension ResultViewController: PickerViewControllerDelegate {
    func didSelectValue(value: Any) {
        if value is String {
            meal = value as! String }
        else {
            selectedFood!.selectedMeasure = value as! Measure
        }
        updateUI()
    }
}


