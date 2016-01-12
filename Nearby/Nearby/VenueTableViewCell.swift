//
//  VenueTableViewCell.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 08/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    
    var tapped: ((VenueTableViewCell) -> Void)?

    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func customAdd(sender: AnyObject) {
        
        tapped?(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
