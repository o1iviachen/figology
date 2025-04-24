//
//  ErrorManager.swift
//  figology-v2
//
//  Created by emily zhang on 2025-04-07.
//

import UIKit

struct AlertManager {
    func showAlert(alertMessage: String, viewController: UIViewController, onDismiss: (() -> Void)? = nil) {
        
        // Create alert with error message
        let alert = UIAlertController(title: "alert", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        // Add dismission option
        alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: { _ in onDismiss?()
        }))
        
        // Present alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
