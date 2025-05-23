/**
 SupportViewController.swift
 figology-v2
 Emily, Olivia, and Su
 This file runs the email support component
 History:
 Mar 26, 2025: File creation
*/

import UIKit
import MessageUI
import Firebase


class SupportViewController: UIViewController {
    let alertManager = AlertManager()
    
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        
        // Round corner of view holding text view; code from https://stackoverflow.com/questions/1509547/giving-uiview-rounded-corners
        viewHolder.layer.cornerRadius = 10;
        viewHolder.layer.masksToBounds = true;
        
        // Keyboard goes down when screen is tapped outside and swipped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        // Send the email; if the email is empty, notify the user
        if textView.text == "" {
            self.alertManager.showAlert(alertMessage: "email body is empty.", viewController: self)
            return
        }
        sendEmail(body: textView.text, controller: self)
    }
    
    
    @objc func handleSwipe() {
        textView.resignFirstResponder()
    }
    
    
    @objc func handleTap() {
        textView.resignFirstResponder()
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension SupportViewController: MFMailComposeViewControllerDelegate {
    
    
    func sendEmail(body: String, controller: SupportViewController) {
        
        // Code from https://stackoverflow.com/questions/65743004/swiftui-send-email-using-mfmailcomposeviewcontroller
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            
            // Prepare email to be sent
            mailComposer.mailComposeDelegate = controller
            mailComposer.setPreferredSendingEmailAddress((Auth.auth().currentUser!.email)!)
            mailComposer.setToRecipients(["olivia63chen@gmail.com"])
            mailComposer.setSubject("inquiry about figology.")
            mailComposer.setMessageBody("\(body)", isHTML: false)
            controller.present(mailComposer, animated: true, completion: nil)
        }
        
        // Show error if email was not prepared
        else {
            self.alertManager.showAlert(alertMessage: "unable to send email.", viewController: self)
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        // Notify email result to user using a pop-up unless cancelled
        case .sent:
            controller.dismiss(animated: true, completion: {
                self.alertManager.showAlert(alertMessage: "email sent!", viewController: self)
            })
        case .saved:
            controller.dismiss(animated: true, completion: {
                self.alertManager.showAlert(alertMessage: "email saved!", viewController: self)
            })
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
            
        case .failed:
            controller.dismiss(animated: true, completion: {
                self.alertManager.showAlert(alertMessage: "the email was not sent.", viewController: self)
            })
        @unknown default:
            break
        }
        
    }
}


