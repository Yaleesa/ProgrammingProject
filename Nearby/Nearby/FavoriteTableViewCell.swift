//
//  FavoriteTableViewCell.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 13/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    /* yay a custom cell */
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
