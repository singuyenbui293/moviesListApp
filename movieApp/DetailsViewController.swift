//
//  DetailsViewController.swift
//  movieApp
//
//  Created by admin on 7/7/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
 
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var backDropImage: UIImageView!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var votePoint: UILabel!
    
    
    var movie = NSDictionary()
    var baseUrl = "https://image.tmdb.org/t/p/w342"
    var lowResImageUrl = "https://image.tmdb.org/t/p/w45"
    var highResImageUrl = "https://image.tmdb.org/t/p/original"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
        
        
        let posterPath = movie ["poster_path"] as! String
        let smallImageUrl = lowResImageUrl + posterPath
        let largeImageUrl = highResImageUrl + posterPath
        let backDropPath = movie ["backdrop_path"] as! String
        let backDropPathURL = baseUrl + backDropPath
        
        let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl)!)
        
        self.backDropImage.setImageWithURL(NSURL(string: backDropPathURL)!)
        
        self.posterImage.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImage.alpha = 0.0
                self.posterImage.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.posterImage.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImage.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImage.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        

        overviewLabel.text = "Overview: \(movie ["overview"] as! String)"
        overviewLabel.sizeToFit()
        
        titleLabel.text = "Title: \(movie ["title"] as! String)"
        releaseDate.text = "Release Date: \(movie["release_date"] as! String)"
        votePoint.text =  "Rate Point: \(movie["vote_average"] as! Double)"
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
