//
//  SearchViewController.swift
//  figology-v2
//
//  Created by olivia chen on 2025-04-02.
//

import UIKit
import Firebase
import FLAnimatedImage

class SearchViewController: UIViewController {
    
    var searchList: [Food?] = []
    var selectedFood: Food? = nil
    var logoView: FLAnimatedImageView!
    let fibreCallManager = FibreCallManager()
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        firebaseManager.fetchRecentFoods { recentFoods in
            self.searchList = recentFoods
            self.resultsTableView.reloadData()
        }
        logoView = FLAnimatedImageView()
        logoView.contentMode = .scaleAspectFit
        let centerX = view.bounds.size.width / 2
        let centerY = view.bounds.size.height / 2
        logoView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        logoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logoView.center = CGPoint(x: centerX, y: centerY)
        logoView.isHidden = true
        view.addSubview(logoView)
        searchTextField.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(UINib(nibName: K.foodCellIdentifier, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
        
    }
    
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    func loadAnimatedGIF() {
        guard let gifURL = URL(string: "https://i.gifer.com/ZKZg.gif") else {
            print("Invalid GIF URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: gifURL) { [weak self] (data, response, error) in
            if let error = error {
                print("Error loading GIF:", error)
                return
            }
            
            if let data = data, let animatedImage = FLAnimatedImage(animatedGIFData: data) {
                DispatchQueue.main.async {
                    self?.logoView.animatedImage = animatedImage
                }
            } else {
                print("Failed to load GIF data")
            }
        }
        
        task.resume()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        loadingUIUpdate()
    }
    
    
    func loadingUIUpdate() {
        if searchTextField.text != "" {
            searchList.removeAll()
            resultsTableView.reloadData()
            searchTextField.endEditing(true)
            logoView.isHidden = false
            loadAnimatedGIF()
        } else {
            searchTextField.placeholder = "Enter a food"
        }
    }
    
    func getFibreData(foodString: String, completion: @escaping () -> Void) {
        let foodRequest = fibreCallManager.prepareFoodRequest(foodSearch: foodString)
        fibreCallManager.performFoodRequest(request: foodRequest) { results in
            var fibreRequests: [URLRequest?] = []
            for result in results {
                let fibreRequest = self.fibreCallManager.prepareFibreRequest(foodRequest: result)
                fibreRequests.append(fibreRequest)
            }
            // might need to change
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
            
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        performSegue(withIdentifier: K.searchResultSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // textfield triggers --> pass reference
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let food = searchTextField.text {
            self.searchList.removeAll()
            getFibreData(foodString: food) {
                DispatchQueue.main.async {
                    self.resultsTableView.heightAnchor.constraint(equalToConstant: CGFloat(62*self.searchList.count)).isActive = true
                    self.logoView.isHidden = true
                    self.resultsTableView.reloadData()
                }
            }
        }
        searchTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loadingUIUpdate()
        return searchTextField.placeholder != "Enter a food"
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        let cellFood = searchList[indexPath.row]
        cell.foodNameLabel.text = cellFood!.food
        let descriptionString = "\(cellFood!.brandName), \(String(format: "%.1f", cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        cell.foodDescriptionLabel.text = descriptionString
        cell.fibreMassLabel.text = "\(String(format: "%.1f", cellFood!.fibrePerGram*cellFood!.multiplier*cellFood!.selectedMeasure.measureMass)) g"
        
        return cell
    }
}
