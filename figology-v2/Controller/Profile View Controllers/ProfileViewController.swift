//
//  ProfileViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit
import Firebase
// delegate design change
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let data = [[Setting(image: UIImage(systemName: "plusminus")!, setting: "Fibre Calculator"), Setting(image: UIImage(systemName: "square.and.pencil")!, setting: "Edit Fibre Goal")], [Setting(image: UIImage(systemName: "wrench.adjustable")!, setting: "Support")], ["Log out"]]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fibreLabel: UILabel!

    
    override func viewWillAppear(_ animated: Bool) {
        userLabel.text = "Current user: \((Auth.auth().currentUser?.email)!)"
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
            
            // fibreLabel.text = "Fibre goal: \(UserDefaults.standard.integer(forKey: "fibreGoal"))g"

        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.profileCellIdentifier, bundle: nil), forCellReuseIdentifier: K.profileCellIdentifier)
        tableView.register(UINib(nibName: K.logOutCellNib, bundle: nil), forCellReuseIdentifier: K.logOutCellIdentifier)
        userLabel.text = "Current user:\n\((Auth.auth().currentUser?.email) ?? "No email")"
        fibreLabel.text = "Fibre goal: 20 g"
            // eventually: \(UserDefaults.standard.integer(forKey: "fibreGoal"))
        tableView.separatorStyle = .none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data[indexPath.section][indexPath.row] is Setting {
            let cellData = data[indexPath.section][indexPath.row] as! Setting
            let cellText = cellData.setting
            let cellImage = cellData.image
            let cell = tableView.dequeueReusableCell(withIdentifier: K.profileCellIdentifier, for: indexPath) as! ProfileCell
            cell.label.text = cellText
            cell.iconImage.image = cellImage
            return cell
        } else {
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: K.logOutCellIdentifier, for: indexPath) as! LogOutCell
            return logOutCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0 // Adjust the value as needed
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // log out button pressed
        if indexPath == [2,0] {
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to log out?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            // Add an UIAlertAction with a handler to perform the segue
            let logOutAction = UIAlertAction(title: "Log out", style: .default) { (action) in
                // Perform the segue when the "Got It!" button is tapped
                do {
                    
                    try Auth.auth().signOut()
                    
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
                    window?.rootViewController = loginVC
                    self.findNavigationController(viewController: window?.rootViewController)?
                        .popToRootViewController(animated: true)
                    

                    self.navigationController?.popToRootViewController(animated: true)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }
            
            logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAction)
            alert.addAction(logOutAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
            
            
        } else if indexPath == [0, 1] {
            performSegue(withIdentifier: K.profileSelectorSegue, sender: self)
        } else if indexPath == [0, 0] {
            performSegue(withIdentifier: K.profileCalculatorSegue, sender: self)
        } else if indexPath == [1, 0] {
            self.performSegue(withIdentifier: K.profileSupportSegue, sender: self)
        }
        
    }
    
    func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToCalculator" {
            let destinationVC = segue.destination as! CalculatorViewController
            destinationVC.backButtonShow = true
        }
    }
    
}


