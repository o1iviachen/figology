//
//  SupportViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit
import MessageUI
import Firebase


class SupportViewController: UIViewController {
    
    @IBOutlet weak var viewHolder: UIView!
    var newTextView: UITextView!
    let errorManager = ErrorManager()
    
    override func viewDidLoad() {
        newTextView = UITextView()
        
        newTextView.backgroundColor = UIColor.white
        viewHolder.translatesAutoresizingMaskIntoConstraints = false
        newTextView.translatesAutoresizingMaskIntoConstraints = false // Important: Disable autoresizing mask
        
        view.addSubview(newTextView)

        // Leading Constraint
        let leadingConstraint = newTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30) // Adjust the constant as needed
        leadingConstraint.isActive = true
        
        // Trailing Constraint
        let trailingConstraint = newTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30) // Adjust the constant as needed
        trailingConstraint.isActive = true
        
        // Center Y Constraint
        let centerYConstraint = newTextView.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor)
        centerYConstraint.isActive = true
        
        // Height Constraint
        let viewHeight = viewHolder.frame.size.height
        
        let heightConstraint = newTextView.heightAnchor.constraint(equalToConstant: viewHeight)
        heightConstraint.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        // Set the desired padding values for top, left, bottom, and right
        let topPadding: CGFloat = 10.0
        let leftPadding: CGFloat = 10.0
        let bottomPadding: CGFloat = 10.0
        let rightPadding: CGFloat = 10.0

        newTextView.textContainerInset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)

        viewHolder.layer.cornerRadius = 10.0
        viewHolder.clipsToBounds = true
        newTextView.font = UIFont.systemFont(ofSize: 16.0)
        newTextView.layer.cornerRadius = 10.0
        newTextView.clipsToBounds = true
        
        
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let emailBody = newTextView.text else {
            self.errorManager.showError(errorMessage: "email body is empty.", viewController: self)
            return
        }
        
        sendEmail(body: emailBody, controller: self)
    }
    
    @objc func handleSwipe() {
        newTextView.resignFirstResponder()
    }
    
    @objc func handleTap() {
        newTextView.resignFirstResponder()
    }
    
    
    
}

//MARK: - MFMailComposeViewControllerDelegate
extension SupportViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(body: String, controller: SupportViewController) {
        if !body.isEmpty {
            // try on physical device
            if MFMailComposeViewController.canSendMail() {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = controller
                mailComposer.setPreferredSendingEmailAddress((Auth.auth().currentUser?.email)!)
                mailComposer.setToRecipients(["olivia63chen@gmail.com"])
                mailComposer.setSubject("Inquiry about figology.")
                mailComposer.setMessageBody("\(body)", isHTML: false)
                controller.present(mailComposer, animated: true, completion: nil)
            } else {
                self.errorManager.showError(errorMessage: "unable to send email. please set up an email account on your device.", viewController: self)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            controller.dismiss(animated: true, completion: {
                self.errorManager.showError(errorMessage: "email sent!", viewController: self)
            })
        case .saved:
            controller.dismiss(animated: true, completion: {
                self.errorManager.showError(errorMessage: "email saved!", viewController: self)
            })
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
            
        case .failed:
            controller.dismiss(animated: true, completion: {
                self.errorManager.showError(errorMessage: "the email was not sent.", viewController: self)
            })
        @unknown default:
            break
        }
        
    }
}


