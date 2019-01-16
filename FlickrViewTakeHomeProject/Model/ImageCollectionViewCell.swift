//  ImageCollectionViewCell.swift
//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/12/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: ImageCollectionViewCell - Customize the cell
//  Cocoapod: SDWebImage - provides an async image downloader with cache support.

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    func addPhotoToCell(photo: Photo) { // set the imageView
        itemImageView.sd_setImage(with: photo.photoURL as URL)
    }
    
}
