//
//  SheetViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-03.
//

import UIKit

class PickerViewController: UIViewController {
    
    var options: [String] = []
    
    @IBOutlet weak var informationPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationPicker.delegate = self
        informationPicker.dataSource = self
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        // picker need better positioning

    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
}
