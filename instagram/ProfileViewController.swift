//
//  ProfileViewController.swift
//  instagram
//
//  Created by Grace Kotick on 6/22/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD
class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var profilePicture = UIImage()
    var posts = [PFObject]()
    var currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.loadData()
        usernameLabel.text = currentUser?.username
        if let  pic = currentUser!["picture"] as? PFFile{
        
            imageView.file = pic
            imageView.loadInBackground()
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setPicture(image: UIImage){
        profilePicture = image
    }
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.imageView.image = editedImage
        self.setPicture(editedImage)
        let file = Post.getPFFileFromImage(editedImage)
        currentUser!["picture"] = file
        currentUser?.saveInBackground()
         // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    func loadData(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var query = PFQuery(className: "Post")
        query.orderByDescending("_created_at")
        query.includeKey("author")
        query.whereKey("author", equalTo: currentUser!)
        query.findObjectsInBackgroundWithBlock{ (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                self.posts = posts!

                self.collectionView.reloadData()
            }else{
                print(error)
            }
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.posts.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! PostCollectionViewCell
        
        
        let post = self.posts[indexPath.row]
        cell.instagramPost = post
        return cell
    }
    
    @IBAction func selectProfilePhoto(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func takeProfilePhoto(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // ... Create the NSURLRequest (myRequest) ...
        self.loadData()
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue"{
            let cell = sender?.superview!!.superview as! UICollectionViewCell
            
            let indexPath = collectionView.indexPathForCell(cell)
            
            let post = posts[indexPath!.row]
            let user = PFUser.currentUser()
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            detailViewController.user = user
            
            detailViewController.post = post
        }         
        
        
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
