//
//  PostCollectionViewCell.swift
//  instagram
//
//  Created by Grace Kotick on 6/22/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    var instagramPost: PFObject! {
        didSet {
            self.postImageView.file = instagramPost["media"] as? PFFile
            self.postImageView.loadInBackground()
            
        }
    }

    
}
