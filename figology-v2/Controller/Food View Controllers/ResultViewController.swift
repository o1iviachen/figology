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
    var measureQuantity = 0.0
    var foodName = ""
    var fibreMass = 0.0
    var descriptionText = ""
    var measureList: [Measure] = []
    var selectedFood: Food? = nil
    var measureDescriptionList: [String] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var fibreLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var servingMeasureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodLabel.text = selectedFood?.food
        fibreLabel.text = "\(String(format: "%.1f", selectedFood!.fibrePerGram*selectedFood!.multiplier)) g"
        descriptionLabel.text = descriptionText
        servingTextField.delegate = self
        servingMeasureButton.setTitle(selectedFood!.selectedMeasure.measureExpression, for: .normal)
        //        if UserDefaults.standard.integer(forKey: "proteinGoal") != 0 {
        //            DispatchQueue.main.async {
        //                self.progressLabel.text = "This is \(Int((Float(self.proteinAmount)/Float(UserDefaults.standard.integer(forKey: "proteinGoal"))*100)))% of your daily goal!"
        //                self.progressBar.progress = Float(self.proteinAmount)/Float(UserDefaults.standard.integer(forKey: "proteinGoal"))
        //            }
        //        } else {
        //            DispatchQueue.main.async {
        //                self.progressLabel.text = "Please set your protein goal."
        //                self.progressBar.isHidden = true
        //            }
        //        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipe() {
        servingTextField.resignFirstResponder()
    }
    
    @objc func handleTap() {
        servingTextField.resignFirstResponder()
    }
}
