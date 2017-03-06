//
//  RecipeDetailViewController.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    public var shownRecipe: Recipe? = nil
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeInstructions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let recipe = self.shownRecipe {
            //set the text
            self.recipeTitle.text = recipe.title
            
            if recipe.imageURL != ""{
                self.recipeRating.text = recipe.rating
                self.recipeInstructions.text = recipe.instructions
                
                
                
            } else {
                
                let populateRecipeDetailsCompletionHandler: (Recipe) -> Void = {[weak self] (updatedRecipe:Recipe) -> Void  in
                    //do something here
                    print("here is my updated Recipe")
                    
                    self?.shownRecipe = updatedRecipe
                    self?.recipeRating.text = self?.shownRecipe?.rating
                    self?.recipeInstructions.text = self?.shownRecipe?.instructions
                    
                    //download the recipe image if there is one
                    if let imageURLString = self?.shownRecipe?.imageURL{
                        self?.recipeImage.downloadImageFromNetworkAtURL(url: imageURLString)
                    }
                    
                }
                NetworkingManager.populateRecipeDetails(recipe: self.shownRecipe!, completionHandler: populateRecipeDetailsCompletionHandler)
                
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
