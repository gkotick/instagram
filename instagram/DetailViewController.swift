//
//  DetailViewController.swift
//  instagram
//
//  Created by Grace Kotick on 6/22/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class DetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLikes: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    var post: PFObject!
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = user.username
        profilePicture.file = user["picture"] as? PFFile
        profilePicture.loadInBackground()
        captionLabel.text = post["caption"] as? String
        let likes = post["likesCount"] as! Int
        numberLikes.text = "\(likes)"
        imageView.file = post["media"] as? PFFile
        imageView.loadInBackground()
        dateLabel.text = post["date"] as! String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func like(sender: AnyObject) {
        
        let likes = post["likesCount"] as? Int
        
        numberLikes.text = "\(Int(likes!) + 1)"
        post["likesCount"] = Int(numberLikes.text!)!
        post.saveInBackground()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
