/**
 SearchViewController.swift
 figology-v2
 Emily, Olivia, and Su
 This file runs the food searching component
 History:
 Apr 4, 2025: File creation
*/

import UIKit
import Firebase

class SearchViewController: UIViewController {
    /**
     A class that allows the Search View Controller to search for food items. Its features include displaying recently consumed foods, allowing users to search for new foods, and navigating the user to a new View Controller to view more details about a food item.
     
     - Properties:
        - resultsTableViewHeightConstraint (Unwrapped NSLayoutConstraint): Dynamically adjusts the height of the Table View.
        - loadingAnimation (Unwrapped UIActivityIndicatorView): Shows a loading animation when the data is being fetched.
        - resultsTableView (Unwrapped UITableView): Displays the food search results or recently added food items.
        - searchTextField ( Unwrapped UITextField): Allows the user to enter the food item to search.
     */
    
    let fibreCallManager = FibreCallManager()
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    var searchList: [Food?] = []
    var selectedFood: Food? = nil
    var tapGesture: UITapGestureRecognizer?
    var swipeGesture: UISwipeGestureRecognizer?
    
    @IBOutlet weak var resultsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        /**
         Called after the View Controller is loaded and displays the user's recently consumed foods.
         */
        
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
        /**
         Calls for the UI to update for a new search.
         
         - Parameters:
            - sender (UIButton): Triggers the search.
         */
        
        // If the search text field is not empty, change UI to loading style
        if searchTextField.text != "" {
            loadingUIUpdate()
        }
    }
    
    
    func loadingUIUpdate() {
        /**
         Updates the UI in preparation for a food search.
         */
        
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
        /**
         Gets the fibre data after performing a food search with the Nutritionix API.
         
         - Parameters:
            - foodString (String): Indicates the food name to search.
            - completion: Signals when the API call is complete.
         */
        
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
        /**
         Prepares and passes the selected foor item data before transitioning to the Results View Controller.
         
         - Parameters:
            - segue (UIStoryboardSegue): Indicates the View Controllers involved in the segue.
            - sender (Optional Any): Indicates the object that initiated the segue.
         */
        
        // If segue being prepared goes to results view controller, pass selected food for results view controller's attributes
        if segue.identifier == K.searchResultSegue {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.selectedFood = selectedFood
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    /**
     An extension that navigates through the application based on the user's interactions with the Results Table View.
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Performs a segue when the user selects a row in the Results Table View.
         
         - Parameters:
            - tableView (UITableView): Contains the row selection information.
            - indexPath (IndexPath): Specifies the row of the selected information.
         */
        
        // If food is selected, perform segue to results view controller
        selectedFood = searchList[indexPath.row]
        performSegue(withIdentifier: K.searchResultSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    /**
     An extension that handles the user's interactions with the search bar, including validating and initiating a search.
     */
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /**
         Performs the search, retrieves fibre data, and adjusts the Results Table View accordingly.
         
         - Parameters:
            - textField (UITextField): Contains the user's food item to search for.
         */
        
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
        /**
         Verifies if the user's search should proceed oncer they press the Return button on their keyboard.
         
         - Parameters:
            - textField (UITextField): Contains the user's food item to search for.
         
         - Returns: A Bool indicating if the editing should end and the keyboard should be minimised.
         */
        
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
    /**
     An extension that prepares the food cells to display in the Results Table View when a food search is performed.
     */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         Determines and retunrs the number of rows to display in the Results Table View.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - section (Int): Contains the number of rows in this section.
         
         - Returns: An Int indicating the number of results from the search, which corresponds to the number of cells to display.
         */
        
        // Required to populate the correct number of foods
        return searchList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         Prepares a reusable Food Cell that is used to display the information for each food item result from the search.
         
         - Parameters:
            - tableView (UITableView): Requests this information
            - indexPath (IndexPath): Indicates the row location of the cell.
         
         - Returns: A UITableViewCell with labels for the corresponding Food object data from the search.
         */
        
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
