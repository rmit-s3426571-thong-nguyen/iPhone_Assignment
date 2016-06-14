//
//  GiphyAdapter.swift
//  GiphyTest
//
//  Created by Nicholas Amor on 6/05/2016.
//  Copyright © 2016 Nick Amor. All rights reserved.
//

import Alamofire
import SwiftyJSON

class GiphyAdapter {
    static let api_key = "dc6zaTOxFJmzC"
    static let host = "http://api.giphy.com"
    
    /** * MARK: REST API functions */
    
    static func trending(completion: (result: JSON) -> Void) {
        let path = "/v1/gifs/trending"
        
        let endpoint = host + path
        
        Alamofire.request(.GET, endpoint, parameters: ["api_key": api_key])
            .responseJSON(completionHandler: { response in
                guard response.result.error == nil else {
                    print(response.request)
                    print(response.result)
                    print(response.result.error)
                    return
                }
                
                if let value = response.result.value {
                    let obj = JSON(value)
                    
                    completion(result: obj)
                }
            })
    }
    
    static func search(query: String, completion: (result: JSON) -> Void) {
        let path = "/v1/gifs/search"
        
        let endpoint = "\(host)\(path)"
        
        Alamofire.request(.GET, endpoint, parameters: ["q": query, "api_key": api_key])
            .responseJSON(completionHandler: { response in
                guard response.result.error == nil else {
                    print(response.request)
                    print(response.result)
                    print(response.result.error)
                    return
                }
                
                if let value = response.result.value {
                    let obj = JSON(value)
                    
                    completion(result: obj)
                }
            })
    }
    
    /** * MARK: adapter functions */
    
    static func gifsFromJson(json: JSON) -> [GiphyGif] {
        var gifs: [GiphyGif] = []
        
        if let data = json["data"].array {
            for item in data {
                let gif = GiphyGif()
                
                gif.id = item["id"].string!
                
                gif.url = item["images"]["original"]["url"].string!
                gif.width = Int(item["images"]["original"]["width"].string!)!
                gif.height = Int(item["images"]["original"]["height"].string!)!
                
                gif.smallUrl = item["images"]["fixed_height_downsampled"]["url"].string!
                gif.smallWidth = Int(item["images"]["fixed_height_downsampled"]["width"].string!)!
                gif.smallHeight = Int(item["images"]["fixed_height_downsampled"]["height"].string!)!
                
                gifs.append(gif)
            }
        }
        
        return gifs
    }
    
    static func getTrendingGifs(completion: (results: [GiphyGif]) -> Void) {
        trending({json in
            completion(results: gifsFromJson(json))
        })
    }
    
    static func getSearchGifs(query: String, completion: (results: [GiphyGif]) -> Void) {
        let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        search(encodedQuery, completion: {json in
            completion(results: gifsFromJson(json))
        })
    }
}
