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
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var recipeInstructions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let recipe = self.shownRecipe {
            
            //set the text
            self.navigationItem.title = self.shownRecipe?.title
            let attrs = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "AvenirNextCondensed-Bold", size: 18)!
            ]
            self.navigationController?.navigationBar.titleTextAttributes = attrs
            
            //if imageURL string is not empty then we can assume the service call
            //for the recipe details has already been done before
            if recipe.imageURL != ""{
                
                // FIXME: - right now only the image is being cached
                //would be nice to cache the other detail properties and rely on them here
                //as it stands right now, this if statement is always false
                self.recipeInstructions.text = recipe.instructions
                
            } else {
                
                //completion handler after retrieving recipe details
                let populateRecipeDetailsCompletionHandler: (Recipe) -> Void = {[weak self] (updatedRecipe:Recipe) -> Void  in
                    //do something here
                    print("here is my updated Recipe")
                    
                    self?.shownRecipe = updatedRecipe

                    
                    if let numStars = self?.shownRecipe?.rating{
                        //sanity check to make sure rating is 1 or higher
                        if (numStars >= 1){
                            //this implementation relies on the fact that the imageViews inside
                            //the horizontal stackview are given tag values of 1 through 5 when
                            //looking at the image views from left to right (left-most view is 
                            //tagged 1, right most view is tagged 5).
                            for i in 1 ... numStars{
                                let currentStarImageView = self?.ratingStackView.viewWithTag(i) as? UIImageView
                                
                                //assign the fill_star.png icon as the image value
                                currentStarImageView!.image = #imageLiteral(resourceName: "fill_star.png")
                            }
                        }
                    }
                    
                    self?.recipeInstructions.text = self?.shownRecipe?.instructions
                    
                    //download the recipe image if there is one
                    if let imageURLString = self?.shownRecipe?.imageURL{
                        self?.recipeImage.downloadImageFromNetworkAtURL(url: imageURLString)
                    }
                    
                }
                
                //perform actual service call for retrieving recipe details
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
