//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/13/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: This class has the implentation of Flickr's Search API


import Foundation

class Flickr {
    
    typealias flickrResponse = (NSError?, [Photo]?) -> Void
    
    // method that implements Flickr's Search API
    class func getPhotosFromSearch(searchText: String, page: Int, onCompletion: @escaping flickrResponse) -> Void {
        
        let flickrAPIKey = "bb791ab5e81cb8f459774788fa1c0380"
        let escapeSearchText: String = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var apiMethod = ""
        
        if escapeSearchText.count > 0 {
            apiMethod = "flickr.photos.search"  // after user searches, use this string to replace in the URL
        } else {
            apiMethod = "flickr.photos.getRecent" // once the main view controller loads, pictures of the "Get Recent" section will display on the CollectionView
        }
        
        let flickrURL: String = "https://api.flickr.com/services/rest/?method=\(apiMethod)&api_key=\(flickrAPIKey)&tags=\(escapeSearchText)&per_page=20&format=json&nojsoncallback=1&page=\(page)"
        
        let url: NSURL = NSURL(string: flickrURL)!
        
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else {
                    return
                }
                
                let invalidAccessErrorCode = 100
                
                if let statusCode = results["code"] as? Int {
                    if statusCode == invalidAccessErrorCode {
                        let invalidError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidError, nil)
                        return
                    }
                }
                
                guard let photoContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                
                guard let photoArray = photoContainer["photo"] as? [NSDictionary] else { return }
                
                let flickrPhotos: [Photo] = photoArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = Photo(title: title, photoId: photoId, farm: farm, secret: secret, server: server)
                    return flickrPhoto
                }
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("JSON Parsing Error: \(error)")
                onCompletion(error, nil)
                return
            }
        })
        searchTask.resume()
    }
}
