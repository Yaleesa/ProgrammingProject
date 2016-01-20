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
    
    //print(FavData())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storedFavorites.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoriteTableViewCell

        
        cell.favLabel.text = storedFavorites[indexPath.row]
        
        let imageName = UIImage(named: storedFavorites[indexPath.row])
        cell.favImage?.image = imageName

        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        FavData()
        self.tableView.reloadData()

    }
    
    func FavData() -> [String] {
        if self.defaults.stringArrayForKey("favoriteKey") != nil{
            storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
        }else{
            storedFavorites = ["No Favorites"]
        }

        return storedFavorites
    }
    
     //Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }
    

    
     //Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete the row from the data source
            storedFavorites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            defaults.setObject(storedFavorites, forKey: "favoriteKey")
            let nearbyView = NearbyViewController()
//            nearbyView.stopMonitoring()
            //nearbyView.restartSearchandMonitor()

            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            
        }
    }

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
