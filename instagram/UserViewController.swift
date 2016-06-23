//
//  UserViewController.swift
//  instagram
//
//  Created by Grace Kotick on 6/22/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    //var post: PFObject!
    var user: PFUser!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = user.username
        profilePicture.file = user["picture"] as? PFFile
        profilePicture.loadInBackground()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        var query = PFQuery(className: "Post")
        query.orderByDescending("_created_at")
        query.includeKey("author")
        query.whereKey("author", equalTo: user)
        query.findObjectsInBackgroundWithBlock{ (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                self.posts = posts!
                
                self.collectionView.reloadData()
            }else{
                print(error)
            }
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenericCollectionCell", forIndexPath: indexPath) as! GenericPostCollectionViewCell
        
        
        let post = self.posts[indexPath.row]
        cell.instagramPost = post
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender?.superview!!.superview as! UICollectionViewCell
        
        let indexPath = collectionView.indexPathForCell(cell)
        
        let post = posts[indexPath!.row]
        let user = post["author"] as! PFUser
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.user = user
        detailViewController.post = post
        
        
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
