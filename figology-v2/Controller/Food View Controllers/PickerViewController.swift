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
        informationPicker.delegate = self
        informationPicker.dataSource = self
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        if let checkedOptions = options as? [String] {
            modifiedOptions = checkedOptions
        } else {
            modifiedOptions = options.map { ($0 as! Measure).measureExpression }
        }
            
    }
}

//MARK: - UIPickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modifiedOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = options[row]
        delegate?.didSelectValue(value: selectedValue)
    }
    
}

//MARK: - UIPickerViewDataSource
extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modifiedOptions.count
    }
    
    
}
