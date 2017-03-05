//
//  NetworkingManager.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
    
    static func loadRecipesWithCompletion(completionHandler:@escaping ([Recipe]) -> Void) -> Void{
        
        
        let recipeRequestString = "http://gl-endpoint.herokuapp.com/recipes"
        
        guard let url = URL(string: recipeRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main)
        
        // make the request with the session
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            //check 1: no errors
            guard error == nil else {
                print("error calling the request:\(error!)")
                return
            }
            
            //check 2: data is non-nil
            guard data != nil else {
                print("Error: data is nil")
                return
            }
            
            //check 3: response parameter is non-nil
            if response != nil {
                do {
                    
                    //JSON response is an array of dictionaries
                    if let jsonDict = try JSONSerialization.jsonObject(with: data!, options: [])as? [[String: Any]]{
                        print(jsonDict)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }

}
