//
//  SearchViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var searchList: [Food?] = []
    var selectedFood: Food? = nil
    let fibreCallManager = FibreCallManager()
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    var tapGesture: UITapGestureRecognizer?
    var swipeGesture: UISwipeGestureRecognizer?
    
    @IBOutlet weak var resultsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show loading animation
        loadingAnimation.isHidden = false
        
        // Fetch user document
        firebaseManager.fetchUserDocument { document in
            
            // Fetch user's recently consumed foods
            self.firebaseManager.fetchRecentFoods(document: document) { recentFoods in
                self.searchList = recentFoods
                
                // Adjust results table view height to fit recent foods; learned why to use DispatchQueue.main.async using https://medium.com/@prabhatkasera/dispatch-async-in-ios-bd32295b042f
                DispatchQueue.main.async {
                    self.resultsTableViewHeightConstraint.constant = CGFloat(62*self.searchList.count)
                }
                
                // Hide loading animation and display recent foods
                self.loadingAnimation.isHidden = true
                self.resultsTableView.reloadData()
            }
        }
        
        // Set self as the results table view's delegate to handle user interactions
        resultsTableView.delegate = self

        // Set self as the results table view's data source to provide the data
        resultsTableView.dataSource = self
        
        // Set self as the search text field's delegate to handle user interactions
        searchTextField.delegate = self
        
        // Register food cell
        resultsTableView.register(UINib(nibName: K.foodCellIdentifier, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        // If the search text field is not empty, change UI to loading style
        if searchTextField.text != "" {
            loadingUIUpdate()
        }
    }
    
    
    func loadingUIUpdate() {
        
        // Clear search list
        searchList.removeAll()
        
        // Reload results table view such that results table view is empty
        resultsTableView.reloadData()
        
        // Show loading animation
        loadingAnimation.isHidden = false
        
        // End editing in search text field (will dismiss keyboard)
        searchTextField.endEditing(true)
    }
    
    
    func getFibreData(foodString: String, completion: @escaping () -> Void) {
        let foodRequest = fibreCallManager.prepareRequest(requestString: foodString, urlString: "https://trackapi.nutritionix.com/v2/search/instant", httpMethod: "POST")
        
        // Perform food request from Nutritionix API using the prepared food request
        fibreCallManager.performFoodRequest(request: foodRequest) { results in
            var fibreRequests: [URLRequest?] = []
            
            // Prepare fibre requests for all returned common foods
            for result in results[0] {
                let fibreRequest = self.fibreCallManager.prepareRequest(requestString: result, urlString: "https://trackapi.nutritionix.com/v2/natural/nutrients", httpMethod: "POST")
                fibreRequests.append(fibreRequest)
            }
            
            // Prepare fibre requests for all returned branded foods
            for result in results[1] {
                let fibreRequest = self.fibreCallManager.prepareRequest(requestString: result, urlString: "https://trackapi.nutritionix.com/v2/search/item", httpMethod: "GET")
                fibreRequests.append(fibreRequest)
            }
            
            // Create a dispatch group; code from https://stackoverflow.com/questions/49376157/swift-dispatchgroup-notify-before-task-finish
            let dispatchGroup = DispatchGroup()
            
            // Perform fibre requests for all foods
            for fibreRequest in fibreRequests {
                dispatchGroup.enter()
                self.fibreCallManager.performFibreRequest(request: fibreRequest) { parsedFood in
                    
                    // If food data was returned, append food data to search list
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
        
        // If segue being prepared goes to results view controller, pass selected food for results view controller's attributes
        if segue.identifier == K.searchResultSegue {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.selectedFood = selectedFood
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If food is selected, perform segue to results view controller
        selectedFood = searchList[indexPath.row]
        performSegue(withIdentifier: K.searchResultSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let food = searchTextField.text {
            
            // Get fibre data; upon completion, hide loading animation
            getFibreData(foodString: food) {
                self.loadingAnimation.isHidden = true
                
                // If no foods were found, display message to user
                if self.searchList.count == 0 {
                    self.alertManager.showAlert(alertMessage: "no foods were found.", viewController: self)
                }
                
                // Otherwise, adjust results table view height and reload results table view data
                else {
                    DispatchQueue.main.async {
                        self.resultsTableViewHeightConstraint.constant = CGFloat(62*self.searchList.count)
                    }
                    self.resultsTableView.reloadData()
                }
            }
        }
        
        // Clear search text field
        searchTextField.text = ""
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // If the text field is not empty, change UI to loading style and end editing in text field (will dismiss keyboard)
        if textField.text != "" {
            loadingUIUpdate()
            textField.endEditing(true)
            return true
        }
        return false
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Required to populate the correct number of foods
        return searchList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a food cell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        
        // Get the required Food object
        let cellFood = searchList[indexPath.row]
        
        // Set the food cell's attributes according to the Food object
        cell.foodNameLabel.text = cellFood!.food
        
        // Calculate the consumed mass
        let descriptionString = "\(cellFood!.brandName), \(String(format: "%.1f", cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        cell.foodDescriptionLabel.text = descriptionString
        
        // Calculate the fibre mass per consumed mass
        cell.fibreMassLabel.text = "\(String(format: "%.1f", cellFood!.fibrePerGram*cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        
        return cell
    }
}
