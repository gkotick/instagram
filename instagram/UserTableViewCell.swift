//
//  UserTableCell.swift
//  instagram
//
//  Created by Grace Kotick on 6/23/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class UserTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profileImage: PFImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    var instagramUser: PFUser! {
        didSet {
            self.profileImage.file = instagramUser["picture"] as? PFFile
            self.profileImage.loadInBackground()

            
        }
    }
}
