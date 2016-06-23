//
//  GenericPostCollectionViewCell.swift
//  instagram
//
//  Created by Grace Kotick on 6/22/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class GenericPostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: PFImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var instagramPost: PFObject! {
        didSet {
            self.imageView.file = instagramPost["media"] as? PFFile
            self.imageView.loadInBackground()
        }
    }
}
