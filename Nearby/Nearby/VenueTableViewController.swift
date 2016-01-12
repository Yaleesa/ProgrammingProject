//
//  VenueTableViewController.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 07/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

class VenueTableViewController: UITableViewController {
    
    //var selectedItem: AnyObject
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    

    var venue = [Venue]()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleVenues()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSampleVenues() {
        let photo1 = UIImage(named: "Apple Store")!
        let venue1 = Venue(name: "Apple Store", photo: photo1)
        
        let photo2 = UIImage(named: "Starbucks")!
        let venue2 = Venue(name: "Starbucks", photo: photo2)
        
        let photo3 = UIImage(named: "Rituals")!
        let venue3 = Venue(name: "Rituals", photo: photo3)
        
        let photo4 = UIImage(named: "Wagamama")!
        let venue4 = Venue(name: "Wagamama", photo: photo4)
        
        let photo5 = UIImage(named: "Coffee Company")!
        let venue5 = Venue(name: "Coffee Company", photo: photo5)
        
        venue += [venue1, venue2, venue3, venue4, venue5]
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
        return venue.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "VenueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! VenueTableViewCell

        cell.tapped = { [unowned self] (selectedCell) -> Void in
            let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
            var selectedItem = self.venue[path.row]
            print(selectedItem.dynamicType)
            
            print("the selected item is \(selectedItem.name)")
        }
        
        let cellVenue = venue[indexPath.row]

        cell.venueLabel.text = cellVenue.name
        cell.venueImage.image = cellVenue.photo
        
        cell.addButton.addTarget(self, action: "addFav:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    override func viewDidAppear(animated: Bool) {
       
        let nav = self.navigationController?.navigationBar

        nav?.barStyle = UIBarStyle.Black

    }
    @IBAction func addFav(sender: AnyObject) {
        
        //print(sender.tag)
        
        let addAlert = UIAlertController(title: "Favorites", message: "Do you want to add ** to your favorites?", preferredStyle: UIAlertControllerStyle.Alert)
        
        addAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            
            if self.defaults.arrayForKey("favoriteKey") != nil{
                var storedFavorites = self.defaults.arrayForKey("favoriteKey")!
                storedFavorites.append(["test"])
                self.defaults.setObject(storedFavorites, forKey: "favoriteKey")
                
                
            }else{
                self.defaults.setObject(["test1"], forKey: "favoriteKey")
                
                
            }
            
//            var favorites = self.defaults.arrayForKey("favoriteKey")!
//            for item in favorites {
//                print(item)
//            }
            

            
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("cancelled")
        }))
        
        presentViewController(addAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
