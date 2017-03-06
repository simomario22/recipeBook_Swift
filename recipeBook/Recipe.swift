//
//  Recipe.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class Recipe: NSObject {

    var id: String
    var title: String
    var rating: Int
    var imageURL: String
    var instructions: String
    
    override init(){
        self.id = ""
        self.title = ""
        self.rating = -1
        self.imageURL = ""
        self.instructions = ""
    }
    
}
