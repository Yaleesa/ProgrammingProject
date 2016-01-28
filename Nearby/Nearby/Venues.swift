//
//  Venues.swift
//  Nearby
//
//  Created by Yaleesa Borgman on 07/01/16.
//  Copyright © 2016 Yaleesa Borgman. All rights reserved.
//

import UIKit

/* data model for the Venue data */
class Venue {
    
    var name: String
    var photo: UIImage?
    
    init(name: String, photo: UIImage?) {
        self.name = name
        self.photo = photo
    }
}