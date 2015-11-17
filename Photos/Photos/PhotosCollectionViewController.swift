//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var photos: [Photo] = []
    
    @IBOutlet var collectionViewMain: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        // FILL ME IN
        self.collectionView!.reloadData()
        
        collectionViewMain.contentInset = UIEdgeInsetsMake(48, 10, 10, 30)
        
    }

    /* 
     * IMPLEMENT ANY COLLECTION VIEW DELEGATE METHODS YOU FIND NECESSARY
     * Examples include cellForItemAtIndexPath, numberOfSections, etc.
     */
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as! PhotoCell
            var photo = photos[indexPath.item]
            loadImageForCell(photo, imageView: cell.imageView)
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(350, 350)
    }
    
    
    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        var imageURL = photo.url
        var url = NSURL(string: imageURL as String)
        var request: NSURLRequest = NSURLRequest(URL: url!)
        var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let image: UIImage = UIImage(data: data!)!
                imageView.image = image
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showPhoto" {
            if segue.destinationViewController is PhotoViewController {
                let photoVC = segue.destinationViewController as! PhotoViewController
                if sender is UICollectionViewCell {
                    let cell = sender as! UICollectionViewCell
                    let row = collectionView!.indexPathForCell(cell)?.row
                    
                    photoVC.photo = photos[row!] as Photo
                }
            }
        }
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
        
    }
    
}

