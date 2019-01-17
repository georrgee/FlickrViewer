//  ImageCollectionViewController.swift
//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/12/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: ImageCollectionViewController shows the user a collection of photos. By using UICollectionView, it will show all photos in a "grid" style. Users can also search for a specific image and the "grid" will reload

import UIKit
import Foundation

class ImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: IBOutlets and variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var flickrPhotos: [Photo] = []
    var page: Int = 1
    
    let cellID = "imageCell"        // Cell Reuse Identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBarSearchButtonClicked(searchBar)
        setupNavBar()
    }
    
    // MARK: IBActions
    @IBAction func resetSearch(_ sender: AnyObject) {
        flickrPhotos.removeAll(keepingCapacity: false)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    // MARK: NavigationBar Setup
    private func setupNavBar() {
        navigationItem.title = "FlickrViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: UICollectionViewDelegate
    
    // Amount of items per section. Hence since we only have one section, this will return the amount of photos
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos.count
    }
    
    // Configuring the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ImageCollectionViewCell
        cell!.addPhotoToCell(photo: flickrPhotos[indexPath.row])
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // using this function, we can use Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == flickrPhotos.count - 1 { 
            if let query = searchBar.text {
                searchWithTextAction(text: query)
            }
        }
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        flickrPhotos.removeAll(keepingCapacity: false)
        searchWithTextAction(text: searchBar.text!)
        collectionView.reloadData()
    }
    
    // Method that will grab the user's input and search for that specific item (i.e. user enters: "Flower", show photos of flowers)
    func searchWithTextAction(text: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Flickr.getPhotosFromSearch(searchText: text, page: page, onCompletion: { (error: NSError?, photos: [Photo]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            // If the data contains more than zero, increment the page number. Hence display more results
            if (photos?.count ?? 0) > 0 {
                self.page += 1
            }
            
            if error == nil {
                self.flickrPhotos.append(contentsOf: photos!)
            } else {
                self.flickrPhotos = []
                
                if (error!.code == 100) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.setupSearchError()
                    })
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionView.reloadData()
            })
            
        })
    }
    
    func setupSearchError(){
        let alertController = UIAlertController(title: "Search Error", message: "API Key must be valid", preferredStyle: .alert)
        let dimissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(dimissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Segue
    
    // Using a segue to go to ImageDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSelectedImage" {
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = collectionView.indexPath(for: cell) {
                    let imageDetailsViewController = segue.destination as! ImageDetailsViewController
                    imageDetailsViewController.flickrPhoto = flickrPhotos[indexPath.row]
                }
            }
        }
    }
}
