//
//  ProfileViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit
import Firebase
// delegate design change
class ProfileViewController: UIViewController {
    let data = [[Setting(image: UIImage(systemName: "plusminus")!, setting: "fibre calculator"), Setting(image: UIImage(systemName: "square.and.pencil")!, setting: "edit fibre goal")], [Setting(image: UIImage(systemName: "wrench.adjustable")!, setting: "support")], ["Log out"]]
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fibreLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the data source of the table view to provide the data
        tableView.dataSource = self
        
        // Set the view controller as the delegate of the table view to handle user interactions
        tableView.delegate = self
        
        // Register employed cells
        tableView.register(UINib(nibName: K.profileCellIdentifier, bundle: nil), forCellReuseIdentifier: K.profileCellIdentifier)
        tableView.register(UINib(nibName: K.logOutCellNib, bundle: nil), forCellReuseIdentifier: K.logOutCellIdentifier)
        
        // Make the seperation rounded
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set user label text to include user's email
        userLabel.text = "current user: \((Auth.auth().currentUser?.email)!)"
        
        // Fetch user document
        firebaseManager.fetchUserDocument { document in
            
            // Fetch and display fibre goal if it exists
            self.firebaseManager.fetchFibreGoal(document: document) { fibreGoal in
                if let safeFibreGoal = fibreGoal {
                    self.fibreLabel.text = "fibre goal: \(safeFibreGoal) g"
                }
                // Otherwise, ask user to set their fibre goal
                else {
                    self.fibreLabel.text = "please set your fibre goal."
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If user is going from profile to calculator, make back button visible
        if segue.identifier == "profileToCalculator" {
            let destinationVC = segue.destination as! CalculatorViewController
            destinationVC.backButtonShow = true
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Required to populate the correct number of sections
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Required to populate the correct number of cells per section
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // If the element is a Setting, create a Profile Cell
        if data[indexPath.section][indexPath.row] is Setting {
            let cellData = data[indexPath.section][indexPath.row] as! Setting
            let cell = tableView.dequeueReusableCell(withIdentifier: K.profileCellIdentifier, for: indexPath) as! ProfileCell
            
            // Set cell attributes as Setting attributes
            cell.label.text = cellData.setting
            cell.iconImage.image = cellData.image
            return cell
        }
        // Otherwise, create a log out cell
        else {
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: K.logOutCellIdentifier, for: indexPath) as! LogOutCell
            return logOutCell
        }
    }
    
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If log out button is pressed
        if indexPath == [2,0] {
            let alert = UIAlertController(title: "are you sure?", message: "do you want to log out?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .default)
            
            // Add an UIAlertAction with a handler to perform the segue
            let logOutAction = UIAlertAction(title: "log out", style: .default) { (action) in
                do {
                    // Sign user out
                    try Auth.auth().signOut()
                    
                    // Return to welcome view controller
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                // If there is a sign out error, communicate to user there is an error using a popup
                catch let signOutError as NSError {
                    self.alertManager.showAlert(alertMessage: signOutError.localizedDescription, viewController: self)
                }
            }
            
            logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAction)
            alert.addAction(logOutAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
            
        // Segue to corresponding view controller based on selected cell
        } else if indexPath == [0, 1] {
            performSegue(withIdentifier: K.profileSelectorSegue, sender: self)
        } else if indexPath == [0, 0] {
            performSegue(withIdentifier: K.profileCalculatorSegue, sender: self)
        } else if indexPath == [1, 0] {
            self.performSegue(withIdentifier: K.profileSupportSegue, sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

}
