//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/13/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Photo.swift contains a struct. According to the documentaion, there are a list of values that needed to be created and stored

import UIKit
import Foundation

struct Photo {
    
    let title: String
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    
    var photoURL: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
}
