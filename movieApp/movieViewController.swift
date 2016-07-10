//
//  movieViewController.swift
//  movieApp
//
//  Created by admin on 7/8/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import MBProgressHUD

class movieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var networkStatusView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func hideStatus(sender: AnyObject) {
        networkStatusView.hidden = true
        tableview.reloadData()
        collectionView.reloadData()
    }
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    @IBAction func segmentAction(sender: AnyObject) {
        switch (segments.selectedSegmentIndex) {
        case 0:
            tableview.hidden = false
            collectionView.hidden = true
        case 1:
            tableview.hidden = true
            collectionView.hidden = false
        default:
            break
        }

    }
    
    
    var movies = [NSDictionary]()
    var baseUrl = "https://image.tmdb.org/t/p/w342"
    let searchController = UISearchController(searchResultsController: nil)
    var endpoint = ""
    var filteredData = [NSDictionary]()
    var listOftitle = [NSDictionary] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkStatusView.hidden = true
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        tableview.dataSource = self
        tableview.delegate = self
        
        filteredData = movies
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableview.insertSubview(refreshControl, atIndex: 0)
        
        switch (segments.selectedSegmentIndex) {
        case 0:
            tableview.hidden = false
            collectionView.hidden = true
        case 1:
            tableview.hidden = true
            collectionView.hidden = false
        default:
            break
        }
        
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                  
                    self.movies = responseDictionary ["results"] as! [NSDictionary]
                    let title = responseDictionary ["results"]!
                    print(title)
            
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.tableview.reloadData()
                    refreshControl.endRefreshing()
                   self.collectionView.reloadData()
            
                    print(self.movies)
                 
                    
                    print("333333333332314123412341234123412341234123412341234123412341234123421341234213434122341234")

                    
                }
            } else if error != nil {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.networkStatusView.hidden = false
            }
        })
        task.resume()
    }
    
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary ["results"] as! [NSDictionary]
                    
                    
                    self.tableview.reloadData()
                    self.collectionView.reloadData()
                    refreshControl.endRefreshing()
                    self.networkStatusView.hidden = true
                }
            }  else if error != nil {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.networkStatusView.hidden = false
            }
        })
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //*********************************************************************************************************************************************************************************

    
    // CollectionView Edit
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell2", forIndexPath: indexPath) as! movieCellCollectionViewCell
        let posterUrlString = baseUrl + (movies [indexPath.row] ["poster_path"] as! String)
        cell.posterImage.setImageWithURL(NSURL(string: posterUrlString)!)
        cell.titleLabel.text = movies[indexPath.row] ["title"] as! String
        cell.voteLabel.text = "rate: \(movies[indexPath.row] ["vote_average"] as! Double)"
        
        let populariryNum = movies[indexPath.row] ["popularity"] as! Double
        let roundUpNumb = String(format: "%.1f", populariryNum)
        
        cell.popular.text = "popularity: \(roundUpNumb)"
        
        
       
        return cell
    }
    
    //*********************************************************************************************************************************************************************************

    
    //TableView Edit.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! movieTableViewCell
        cell.titleLabel.text = movies[indexPath.row] ["title"] as! String
        cell.overviewLabel.text = movies[indexPath.row] ["overview"] as! String
        cell.releaseDate.text = "Release Date: \(movies[indexPath.row]["release_date"] as! String)"
        cell.selectionStyle = .Blue
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.yellowColor()
        cell.selectedBackgroundView = backgroundView
        
        let posterUrlString = baseUrl + (movies [indexPath.row] ["poster_path"] as! String)
        
        let myImage = cell.posterImage
        
        let imageUrl = posterUrlString
        let imageRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        myImage.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    myImage.alpha = 0.0
                    myImage.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        myImage.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    myImage.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        
        
        return cell
    }
    
    //*********************************************************************************************************************************************************************************
 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch (segments.selectedSegmentIndex) {
        case 0:
            let cell = sender as! UITableViewCell
            let indexPath = tableview.indexPathForCell(cell)
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.movie = movie

        case 1:
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.movie = movie

        default:
            break
        }
        
        
        
    }
    
    
}
