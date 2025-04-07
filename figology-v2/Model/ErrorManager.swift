//
//  ErrorManager.swift
//  figology-v2
//
//  Created by emily zhang on 2025-04-07.
//

import UIKit



struct ErrorManager {
    func showError(errorMessage:String,viewController:UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorMessage,preferredStyle:UIAlertController.Style.alert)
        
alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
