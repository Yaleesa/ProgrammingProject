//
//  VenueTableViewController.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 07/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

class VenueTableViewController: UITableViewController {
    
    @IBOutlet var venueTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var venue = [Venue]()
    
    var filtered = [String]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Load the data for the tableview */
        loadSampleVenues()
        
        /* when the application is killed and started again, the application will run without having to go to he MapviewController */
        /* Logical place for this would be app delegete, but somehow all notifications stop when its put there */
        if self.defaults.stringArrayForKey("favoriteKey") != nil{
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        }
    }
    
    /* table values */
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
        
        let photo6 = UIImage(named: "Albert Heijn")!
        let venue6 = Venue(name: "Albert Heijn", photo: photo6)
        
        venue += [venue1, venue2, venue3, venue4, venue5, venue6]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    /* fills cell with data, NOTE: gives error, still works */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "VenueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! VenueTableViewCell
        
        /* receives which item from the table is tapped */
        cell.tapped = { [unowned self] (selectedCell) -> Void in
            _ = tableView.indexPathForRowAtPoint(selectedCell.center)!
        }
        
        let cellVenue = venue[indexPath.row]

        cell.venueLabel.text = cellVenue.name
        cell.venueImage.image = cellVenue.photo
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addFav:", forControlEvents: .TouchUpInside)
        cell.separatorInset = UIEdgeInsetsZero;
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        let image = UIImage(named: "barImage2")! as UIImage
        nav!.setBackgroundImage(image, forBarMetrics: .Default)


//        nav?.barStyle = BarTintColor.UIColor.colorWithRedGreenBlueAlpha(0, 179, 226, 1);
    }
    
    /* Button for adding the venues to favorites, launches a UIAlert and check of its already in favorites, */
    /* if not its added to NSUserdefault */
    @IBAction func addFav(sender: AnyObject) {
     
        let addAlert = UIAlertController(title: "Favorites", message: "Do you want to add \(venue[sender.tag].name) to your favorites?", preferredStyle: UIAlertControllerStyle.Alert)
        
        addAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in
            if self.defaults.stringArrayForKey("favoriteKey") != nil{
                var storedFavorites = self.defaults.stringArrayForKey("favoriteKey")!
                if storedFavorites.contains("\(self.venue[sender.tag].name)") {
                    print("zit er al in")
                } else {
                    storedFavorites.append("\(self.venue[sender.tag].name)")
                    self.defaults.setObject(storedFavorites, forKey: "favoriteKey")
                }
            }else{
                self.defaults.setObject(["\(self.venue[sender.tag].name)"], forKey: "favoriteKey")
            }
            
            /* notification for reloading the regions to monitor when adding a new object */
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
           
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            //cancelled
        }))
    
        presentViewController(addAlert, animated: true, completion: nil)
    }
    
    /*EXTRA STUFF FROM APPLE*/
    

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
