//
//  ErrorManager.swift
//  figology-v2
//
//  Created by emily zhang on 2025-04-07.
//

import UIKit

struct AlertManager {
    func showAlert(alertMessage: String, viewController: UIViewController) {
        
            // Create alert with error messahe
            let alert = UIAlertController(title: "alert", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
            // Add dismission option
            alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: nil))
        
            // Present alert
            viewController.present(alert, animated: true, completion: nil)
    }
}
