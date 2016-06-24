//
//  PostTableViewCell.swift
//  instagram
//
//  Created by Grace Kotick on 6/20/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var closedHeart: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var instagramPost: PFObject! {
        didSet {
            self.postImage.file = instagramPost["media"] as? PFFile
            self.postImage.loadInBackground()
            let user = instagramPost["author"] as! PFUser
            self.profilePicture.file = user["picture"] as? PFFile
            
            self.profilePicture.loadInBackground()
            
        }
    }

}
