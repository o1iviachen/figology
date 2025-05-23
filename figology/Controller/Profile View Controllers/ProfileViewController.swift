/**
 ProfileViewController
 figology-v2
 Emily, Olivia, and Su
 This file runs the user profile components
 History:
 Mar 26, 2025: File creation
*/

import UIKit
import Firebase
// delegate design change
class ProfileViewController: UIViewController {
    /**
     A class that allows the Profile View Controller to display the user's profile information and settings. The information that it displays includes the user's email, fibre goal, and a list of available edits for the user's profile.
     
     - Properties:
        - tableView (Unwrapped UITableView): Displays the user's profile options.
        - userLabel (Unwrapped UILabel): Displays the user's email.
        - fibreLabel (Unwrapped UILabel): Displays the user's fibre goal.
     */
    
    let data = [[Setting(image: UIImage(systemName: "plusminus")!, setting: "fibre calculator"), Setting(image: UIImage(systemName: "square.and.pencil")!, setting: "edit fibre goal")], [Setting(image: UIImage(systemName: "wrench.adjustable")!, setting: "support")], ["Log out"]]
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fibreLabel: UILabel!

    
    override func viewDidLoad() {
        /**
         Called after the View Controller is loaded to set up the Profile View Controller's Table View with custom cells.
         */
        
        super.viewDidLoad()
        
        // Set self as the table view's data source to provide the data
        tableView.dataSource = self
        
        // Set self as the table view's delegate to handle user interaction
        tableView.delegate = self
        
        // Register employed cells
        tableView.register(UINib(nibName: K.profileCellIdentifier, bundle: nil), forCellReuseIdentifier: K.profileCellIdentifier)
        tableView.register(UINib(nibName: K.logOutCellNib, bundle: nil), forCellReuseIdentifier: K.logOutCellIdentifier)
        
        // Make the cells rounded
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        /**
         Called just before the View Controller is loaded and updates the View Controller based on the user's specific information.
         
         - Parameters:
            - animated (Bool): Indicates if the appearance is animated.
         */
        
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
        /**
         Updates the UI in preparation for the segue to the Calculator View Controller.
         
         - Parameters:
            - segue (UIStoryboardSegue): Indicates the View Controllers involved in the segue.
            - sender (Optional Any): Indicates the object that initiated the segue.
         */
        
        // If user is going from profile to calculator, make back button visible
        if segue.identifier == "profileToCalculator" {
            let destinationVC = segue.destination as! CalculatorViewController
            destinationVC.backButtonShow = true
        }
    }
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    /**
     An extension that specifies the sections, rows, and cells for the Table View.
     */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /**
         Returns the number of sections needed.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
         
         - Returns: An Int indicating the number of sections.
         */
        
        // Required to populate the correct number of sections
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         Returns the number of rows for a given section.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - section (Int): Indicates the section.
         
         - Returns: An Int indicating the number of rows.
         */
        
        // Required to populate the correct number of cells per section
        return data[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         Sets up and return the cell for a given section and row.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - indexPath(IndexPath): Specifies the section and row.
         
         - Returns: A UITableViewCell with the correct formal and information.
         */
        
        // If the element is a Setting, create a Profile cell
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
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: K.logOutCellIdentifier, for: indexPath) 
            return logOutCell
        }
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    /**
     An extention that allows the user to edit their profile.
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Performs different actions based on the cell that the user selects, including navigating and logging out.
         
         - Parameters:
            - tableView (UITableView): Informs the delegate of the row selection.
            - indexPath (IndexPath): Specifies the row the user selected.
         */
        
        // If log out button is pressed
        if indexPath == [2,0] {
            let alert = UIAlertController(title: "are you sure?", message: "do you want to log out?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .default)
            
            // Add a log out UIAlertAction with a handler to perform the segue
            let logOutAction = UIAlertAction(title: "log out", style: .default) { (action) in
                do {
                    
                    // Sign user out
                    try Auth.auth().signOut()
                    
                    // Return to welcome view controller
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                // If there is a sign out error, communicate to user there is an error
                catch let signOutError as NSError {
                    self.alertManager.showAlert(alertMessage: signOutError.localizedDescription, viewController: self)
                }
            }
            
            logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAction)
            alert.addAction(logOutAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        // Segue to corresponding view controller based on selected cell
        else if indexPath == [0, 1] {
            performSegue(withIdentifier: K.profileSelectorSegue, sender: self)
        } else if indexPath == [0, 0] {
            performSegue(withIdentifier: K.profileCalculatorSegue, sender: self)
        } else if indexPath == [1, 0] {
            self.performSegue(withIdentifier: K.profileSupportSegue, sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /**
         Sets the height for the header in each section in the Table View.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - section (Int): Specifies the section the header is for.
         
         - Returns: A CGFloat indicating the height of the header.
         */
        
        return 10.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /**
         Creates a transparent UI View to separate the different sections of the Table View.
         
         - Parameters:
            - tableVIew (UITableView): Requests this information.
            - section (Int): Specifieis the section the header is for.
         
         - Returns: An Optional UIView with a clear background for spacing and separation.
         */
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
