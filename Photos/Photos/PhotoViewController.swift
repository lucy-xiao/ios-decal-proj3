//
//  PhotoViewController.swift
//  Photos
//
//  Created by Lucy Xiao on 11/15/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var imageDisplay: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var datePosted: UILabel!
    @IBOutlet var numLikes: UILabel!
    @IBOutlet var likedButton: UIButton!
    var clicked = false
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.text = photo.username
        self.numLikes.text = String(photo.likes)
        loadImageForCell(photo, imageView: imageDisplay)
        

    }
    func resizeImage(image: UIImage) -> UIImage {
        let newHeight = CGFloat(350)
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        var imageURL = photo.url
        var url = NSURL(string: imageURL as String)
        var request: NSURLRequest = NSURLRequest(URL: url!)
        var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            let image: UIImage = UIImage(data: data!)!
            imageView.image = self.resizeImage(image)
        })
    }
    
    @IBAction func clickLiked() {
        print("clickLiked")
        if self.clicked {
            self.likedButton.setTitle("❤️", forState: UIControlState.Normal)
            self.clicked = false
            print("clickLiked.clicked inside true = ", self.clicked)
        } else {
            self.likedButton.setTitle("💖", forState: UIControlState.Normal)
            self.photo.likes! += 1
            self.numLikes.text = String(photo.likes)
            self.clicked = true
            print("clickLiked.clicked inside false = ", self.clicked)
        }
        
    }
}
