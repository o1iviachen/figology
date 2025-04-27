//
//  SearchViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    var searchList: [Food?] = []
    var selectedFood: Food? = nil
    let fibreCallManager = FibreCallManager()
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    
    @IBOutlet weak var resultsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingAnimation.isHidden = false
        
        
        // Fetch user document
        firebaseManager.fetchUserDocument { document in
            
            // Fetch user's recently consumed foods
            self.firebaseManager.fetchRecentFoods(document: document) { recentFoods in
                self.loadingAnimation.isHidden = true
                
                print(recentFoods)
                // Show recently consumed foods before user searches anything
                self.searchList = recentFoods
                
                // Adjust results table view height to fit recent foods
                DispatchQueue.main.async {
                    self.resultsTableViewHeightConstraint.constant =  CGFloat(62*self.searchList.count)
                    self.loadingAnimation.isHidden = true
                }
                self.resultsTableView.reloadData()
            }
        }
        
        
        // Set the view controller as the delegate of the results table view to handle user interactions
        resultsTableView.delegate = self

        // Set the view controller as the data source of the results table view to provide the data
        resultsTableView.dataSource = self
        
        // Set the view controller as the delegate of the search text field to handle user interactions
        searchTextField.delegate = self
        
        // Register food cell
        resultsTableView.register(UINib(nibName: K.foodCellIdentifier, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        loadingUIUpdate()
    }
    
    
    func loadingUIUpdate() {
        if searchTextField.text != "" {
            // Clear seach list
            searchList.removeAll()
            
            // Reload results table view such that results table view is empty
            resultsTableView.reloadData()
            
            searchTextField.endEditing(true)
            loadingAnimation.isHidden = false
        } else {
            
            // If searchTextField is empty, tell user to enter food.
            searchTextField.placeholder = "Enter a food"
        }
    }
    
    func getFibreData(foodString: String, completion: @escaping () -> Void) {
        
        let foodRequest = fibreCallManager.prepareRequest(requestString: foodString, url: "https://trackapi.nutritionix.com/v2/search/instant")
        
        // Perform food request from Nutrionix API using prepared food request
        fibreCallManager.performFoodRequest(request: foodRequest) { results in
            var fibreRequests: [URLRequest?] = []
            
            // Prepare a fibre request for all returned FoodRequests
            for result in results {
                let fibreRequest = self.fibreCallManager.prepareRequest(requestString: result, url: "https://trackapi.nutritionix.com/v2/natural/nutrients")
                fibreRequests.append(fibreRequest)
            }
            
            // Create a dispatch group
            let dispatchGroup = DispatchGroup()
            
            for fibreRequest in fibreRequests {
                dispatchGroup.enter()
                
                self.fibreCallManager.performFibreRequest(request: fibreRequest) { parsedFood in
                    if let safeFood = parsedFood {
                        self.searchList.append(safeFood)
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Notify dispatch group that fibre requests are complete
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If segue being prepared goes to results view controller, pass selectedFood for results view controller's attributes
        if segue.identifier == K.searchResultSegue {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.selectedFood = selectedFood
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFood = searchList[indexPath.row]
        
        // If food is selected, perform segue to results view controller
        performSegue(withIdentifier: K.searchResultSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // Before text field actually ends editing, check if the textfield is empty. If not, allow editing to finish
        if textField.text != "" {
            return true
        }
        
        // Otherwise, communicate to user to type something
        else {
            textField.placeholder = "Type something"
            return false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let food = searchTextField.text {
            // Get fibre data. Upon completion, adjust results table view height, hide loading animation and reload results table view data.
            getFibreData(foodString: food) {
                DispatchQueue.main.async {
                    self.loadingAnimation.isHidden = true
                    if self.searchList.count == 0 {
                        self.alertManager.showAlert(alertMessage: "no foods were found.", viewController: self)
                    } else {
                        self.resultsTableViewHeightConstraint.constant =  CGFloat(62*self.searchList.count)
                        self.resultsTableView.reloadData()
                    }
                }
            }
        }
        // Clear search text field
        searchTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Determine if text field should return logically depending on if it should finishing editing
        loadingUIUpdate()
        return searchTextField.placeholder != "Type something"
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Required to populate the correct number of foods
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        
        // Get the required Food object
        let cellFood = searchList[indexPath.row]
        
        // Access a food cell's attributes to customise the cells according to Food object
        cell.foodNameLabel.text = cellFood!.food
        
        // Calculate the consumed mass
        let descriptionString = "\(cellFood!.brandName), \(String(format: "%.1f", cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        cell.foodDescriptionLabel.text = descriptionString
        
        // Calculate the fibre mass per consumed mass
        cell.fibreMassLabel.text = "\(String(format: "%.1f", cellFood!.fibrePerGram*cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        
        return cell
    }
}
