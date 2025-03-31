//
//  ProfileCell.swift
//  figology-v2
//
//  Created by olivia chen on 2025-03-26.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
