//
//  ErrorManager.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-04.
//

import UIKit

struct ErrorManager {
    func showError(errorMessage: String, viewController: UIViewController) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
    }
}
