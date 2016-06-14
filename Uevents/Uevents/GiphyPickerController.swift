//
//  GiphyPickerController.swift
//  Uevents
//
//  Created by Nicholas Amor on 16/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import UIKit
import FLAnimatedImage
import Alamofire

protocol GiphyPickerDelegate: class {
    func pickedGif(gif: GiphyGif)
}

class GiphyPickerController: UITableViewController {
    var gifs: [GiphyGif] = []
    var searchGifs: [GiphyGif] = []
    let searchController = UISearchController(searchResultsController: nil)
    weak var delegate: GiphyPickerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // install search bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        GiphyAdapter.getTrendingGifs({results in
            self.gifs = results
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchController.active && searchController.searchBar.text != "" {
            return searchGifs.count
        }
        return gifs.count
    }
    
    // show previews
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GiphyTableViewCell
        
        let gif: GiphyGif
        if searchController.active && searchController.searchBar.text != "" {
            gif = searchGifs[indexPath.row]
        } else {
            gif = gifs[indexPath.row]
        }
        
        // set image
        Alamofire.request(.GET, gif.smallUrl)
            .responseData { response in
                if let data = response.result.value {
                    let image = FLAnimatedImage(animatedGIFData: data)
                    
                    cell.giphyImageView.animatedImage = image
                }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pickedGif: GiphyGif
        
        if searchController.active && searchController.searchBar.text != "" {
            pickedGif = searchGifs[indexPath.row]
        } else {
            pickedGif = gifs[indexPath.row]
        }
        
        delegate?.pickedGif(pickedGif)
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func filterContentByQuery(query: String) {
        GiphyAdapter.getSearchGifs(query, completion: { (results) in
            self.searchGifs = results
            self.tableView.reloadData()
            print(results.count)
        })
    }
}

extension GiphyPickerController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentByQuery(searchBar.text!)
    }
}

extension GiphyPickerController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentByQuery(searchBar.text!)
    }
}
