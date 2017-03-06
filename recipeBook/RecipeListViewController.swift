//
//  RecipeListViewController.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeTableView: UITableView!
    
    private var recipeArray: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title
        self.navigationItem.title = "Recipes"
        
        // Do any additional setup after loading the view.
        self.recipeTableView.dataSource = self
        self.recipeTableView.delegate = self
        
        let loadRecipesCompletionHandler: ([Recipe]) -> Void = {[weak self] (recipeArray:[Recipe]) -> Void  in
            //do something here
            
            /*
             DEBUG CODE
            print("here is my completion handler")
            for recipe in recipeArray{
                print("currentRecipe.id = \(recipe.id)")
                print("currentRecipe.title = \(recipe.title)")
            }
            */
            
            self?.recipeArray = recipeArray
            self?.recipeTableView.reloadData()
        }
        
        NetworkingManager.loadRecipesWithCompletion(completionHandler:loadRecipesCompletionHandler)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //make sure the size of the title is the same every time the table view appears
        // FIXME: - the size of the title screen will flash when popping detail view controller
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "AvenirNextCondensed-Bold", size: 36)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
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
    
    
    // MARK: - 
    // MARK: UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCellID", for:indexPath)
        
        let recipeLabel: UILabel = cell.viewWithTag(99) as! UILabel
        recipeLabel.text = recipeArray[indexPath.row].title

        //styling for text in each row
        recipeLabel.font = UIFont(name: "AvenirNextCondensed-Regular", size: 18)!
        recipeLabel.textColor = UIColor.black
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRecipe: Recipe = self.recipeArray[indexPath.row]
        
        //if imageURL string is not empty then assume the service call
        //for the recipe details has already been done before
        if selectedRecipe.imageURL != ""{
            
            //immediately push the detail view controller with the recipe object
            //since we know that the recipe model is populated with details
            let detailVC: RecipeDetailViewController = RecipeDetailViewController()
            detailVC.shownRecipe = selectedRecipe
            self.navigationController?.pushViewController(detailVC, animated: true)
        
        } else {
            
            //TODO: - think about showing an activity indicator here 
            //while the service call for the details is running
            
            //completion handler after retrieving recipe details
            let populateRecipeDetailsCompletionHandler: (Recipe) -> Void = {[weak self] (updatedRecipe:Recipe) -> Void  in
                
                //update the element in the recipe array with an updated recipe model object
                self?.recipeArray[indexPath.row] = updatedRecipe
                
                //now push the detail view controller with the updated recipe object
                let detailVC: RecipeDetailViewController = RecipeDetailViewController()
                detailVC.shownRecipe = updatedRecipe
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            //perform actual service call for retrieving recipe details
            NetworkingManager.populateRecipeDetails(recipe: selectedRecipe, completionHandler: populateRecipeDetailsCompletionHandler)
        }
        
    }

}
