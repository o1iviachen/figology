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
    
    override func viewDidLoad() {
        <#code#>
    }
    var logoView: FLAnimatedImageView!
    func loadAnimatedGIF() {
            guard let gifURL = URL(string: "https://i.pinimg.com/originals/49/23/29/492329d446c422b0483677d0318ab4fa.gif") else {
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
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
}

extension UITextFieldDelegate {
    
    
    
}

