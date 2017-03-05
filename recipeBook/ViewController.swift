//
//  ViewController.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadRecipesCompletionHandler: ([Recipe]) -> Void = { (recipeArray:[Recipe]) -> Void  in
            //do something here
            print("here is my completion handler")
        }
        
        NetworkingManager.loadRecipesWithCompletion(completionHandler:loadRecipesCompletionHandler)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

