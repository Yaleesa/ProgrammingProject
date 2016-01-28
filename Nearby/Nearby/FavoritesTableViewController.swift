//
//  FavoritesTableViewController.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 08/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var storedFavorites: [String] = ["No Favorites"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* get the data! */
        favData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedFavorites.count
    }

    /* shows the data, received from storedFavorites */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoriteTableViewCell

        cell.favLabel.text = storedFavorites[indexPath.row]
        let imageName = UIImage(named: storedFavorites[indexPath.row])
        cell.favImage?.image = imageName

        return cell
    }
    
    /* reloads when the view appears to make sure the data is correct */
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        let image = UIImage(named: "barImage2")! as UIImage
        nav!.setBackgroundImage(image, forBarMetrics: .Default)
        favData()
        self.tableView.reloadData()
    }
    
    /* getting the data from NSUserdefaults, if its empty, its empty */
    func favData() -> [String] {
        if self.defaults.stringArrayForKey("favoriteKey") == nil{
            storedFavorites = ["No Favorites"]
        } else if self.defaults.stringArrayForKey("favoriteKey")! == [] {
            storedFavorites = ["No Favorites"]
        } else {
            storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
        }
        return storedFavorites
    }
    
    /* enabled to allow editing */
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }

    /* delete edit is added, user can swipe and delete a favorite from the the table, table and app will update with the new info */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            storedFavorites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            defaults.setObject(storedFavorites, forKey: "favoriteKey")
            
            favData()
            self.tableView.reloadData()

            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        }
    }
    
    
    /* EXTRA APPLE STUFF */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
