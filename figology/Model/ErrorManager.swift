/**
 ErrorManager.swift
 figology-v2
 Emily, Olivia, and Su
 This file runs the app alerts
 History:
 Apr 7, 2025: File creation
*/

import UIKit

struct AlertManager {
    
    
    func showAlert(alertMessage: String, viewController: UIViewController, onDismiss: (() -> Void)? = nil) {
        
        // Create alert with message argument
        let alert = UIAlertController(title: "alert", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        // Add dismiss option that can call a chosen function
        alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: { _ in onDismiss?()
        }))
        
        // Present alert on chosen view controller
        viewController.present(alert, animated: true, completion: nil)
    }
}
