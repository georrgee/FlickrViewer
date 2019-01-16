//  ImageDetailsViewController.swift
//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/12/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Here we have the ImageDetailsViewController. This is where we can show the user a larger image size of the specific photo they choose.

import UIKit
import SDWebImage

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet weak var specificImageView: UIImageView!
    var flickrPhoto: Photo? // an instance variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageToImageView()
        setupNavigationBar()
        //printImageInfoToConsole()
    }
    
    // Method that sets the downloaded image to specificImageView outlet
    func setImageToImageView() {
        if flickrPhoto != nil {
            specificImageView.sd_setImage(with: flickrPhoto!.photoURL as URL)
        }
    }
    
    // MARK: Navigation Bar UI
    func setupNavigationBar() {
        
        // Setting the title of the Image to Navigation Bar
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.text = flickrPhoto?.title
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        navigationItem.titleView = label
        navigationItem.largeTitleDisplayMode = .never
    
        // creating a back bar button. Customizing Back Button by using an Image Literal
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-icon")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-icon")
        
        // setting up a right bar button for the navigation bar
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: objc Functions
    
    // Method that allows user's to save the image
    @objc func saveButtonTapped() {
        UIImageWriteToSavedPhotosAlbum(specificImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // Method that checks if saving the image was a success. Show status by showing Alerts
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
                let ac = UIAlertController(title: "Saving Image Error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Image Saved", message: "This image is now saved in your camera roll!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Awesome!", style: .default))
                present(ac, animated: true)
        }
    }
//    // MARK: Testing
//
//    // Mehthod that prints out the specific FlickrPhoto Info
//    private func printImageInfoToConsole() {
//                print("START")
//                print(flickrPhoto?.farm)
//                print(flickrPhoto?.photoId)
//                print(flickrPhoto?.photoURL)
//                print(flickrPhoto?.secret)
//                print(flickrPhoto?.server)
//                print(flickrPhoto?.title)
//                print("END")
//    }
    
}
