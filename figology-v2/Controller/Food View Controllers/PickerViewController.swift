//
//  SheetViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-03.
//

import UIKit

protocol PickerViewControllerDelegate: AnyObject {
    func didSelectValue(value: Any)
}

class PickerViewController: UIViewController {
    
    weak var delegate: PickerViewControllerDelegate?
    var options: [Any] = []
    var modifiedOptions: [String] = []
    
    @IBOutlet weak var informationPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the delegrate of the information picker to handle user interactions
        informationPicker.delegate = self
        
        // Set the view controller as the delegrate of the information picker to provide the data
        informationPicker.dataSource = self
        
        // Modify high of picked to 50% of the screen; code from https://stackoverflow.com/questions/68107275/swift-5-present-viewcontroller-half-way
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        // If the options are strings (meal titles), let picker options be the unmodified options
        if let checkedOptions = options as? [String] {
            modifiedOptions = checkedOptions
        }
        
        // Otherwise, the options are Measures; therefore, make the picker options be the measures' measure expressions
        else {
            modifiedOptions = options.map { ($0 as! Measure).measureExpression }
        }
            
    }
}

//MARK: - UIPickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Gets selected string from picker options
        return modifiedOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Gets selected value from unmodified options
        let selectedValue = options[row]
        
        // Allow delegate to perform action with selected value
        delegate?.didSelectValue(value: selectedValue)
    }
    
}

//MARK: - UIPickerViewDataSource
extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        // Returns the number of columns in a picker view
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // Returns the number of rows in a picker view
        return modifiedOptions.count
    }
    
    
}
