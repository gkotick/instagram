//
//  SearchViewController.swift
//  instagram
//
//  Created by Grace Kotick on 6/23/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    var users = [PFUser]()
    var filteredUsers = [PFUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        self.loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        
            
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var query = PFQuery(className: "_User")
        query.orderByDescending("_created_at")
        query.findObjectsInBackgroundWithBlock{ (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                self.users = (users as? [PFUser])!
                self.filteredUsers = self.users
                self.tableView.reloadData()
                print(self.users)
            }else{
                print(error)
            }
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableViewCell
        let user = filteredUsers[indexPath.row]
        cell.userLabel.text = user.username
        cell.instagramUser = user
        
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender?.superview!!.superview as! UITableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        
        let user = filteredUsers[indexPath!.row]
        let userViewController = segue.destinationViewController as! UserViewController
        userViewController.user = user
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredUsers = users.filter({(user: PFUser) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if (user["username"] as? String)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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
