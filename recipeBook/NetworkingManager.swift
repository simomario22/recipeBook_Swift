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
                    if let jsonArrayOfRecipes = try JSONSerialization.jsonObject(with: data!, options: [])as? [[String: AnyObject]]{
                        
                        //populate array of model objects based on JSON response
                        let recipeArray: [Recipe] = self.processJsonRequestIntoArrayOfRecipes(jsonArray: jsonArrayOfRecipes)
                        
                        //perform completion handler with the array of model objects
                        completionHandler(recipeArray)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }

    
    static func processJsonRequestIntoArrayOfRecipes(jsonArray: [Dictionary<String, AnyObject>]) -> [Recipe]{
        
        var recipeArray: [Recipe] = []
        
        for recipeDictionary in jsonArray{
            let currentRecipe: Recipe = Recipe()
            currentRecipe.id = recipeDictionary["id"]!.stringValue as String
            currentRecipe.title = recipeDictionary["title"] as! String
            recipeArray.append(currentRecipe)
        }

        
        return recipeArray
    }
    
    static func populateRecipeDetails(recipe:Recipe, completionHandler:@escaping (Recipe) -> Void) -> Void{
        
        
        let recipeDetailsRequestString = "http://gl-endpoint.herokuapp.com/recipes/" + recipe.id
        
        
        guard let url = URL(string: recipeDetailsRequestString) else {
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
                    
                    //JSON response is a single dictionary
                    if let jsonRecipeDetails = try JSONSerialization.jsonObject(with: data!, options: [])as? [String: AnyObject]{
                        
                        //convert the JSON dictionary into a recipe object
                        let updatedRecipe: Recipe = self.processJsonRecipeDetails(jsonDict: jsonRecipeDetails)
                            
                        //perform completion handler with the update recipe object
                        completionHandler(updatedRecipe)
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()

    }
    
    static func processJsonRecipeDetails(jsonDict: [String: AnyObject]) -> Recipe{
        
        let updatedRecipe: Recipe = Recipe()
        
        updatedRecipe.id = jsonDict["id"]!.stringValue as String
        updatedRecipe.title = jsonDict["title"] as! String
        updatedRecipe.rating = jsonDict["rating"]!.stringValue as String
        updatedRecipe.imageURL = jsonDict["image"] as! String
        updatedRecipe.instructions = jsonDict["instructions"] as! String
        
        
        return updatedRecipe
    }
    
    
    static func downloadImageAtURL(urlString: String, downloadCompletionHandler:@escaping ((Data)->Void)){
        
        guard let url = URL(string: urlString) else {
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
                downloadCompletionHandler(data!)
            } else {
                print("Error: response in nil")
            }
        }
        
        task.resume()
    }


}
