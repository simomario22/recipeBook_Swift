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
        
        // Do any additional setup after loading the view.
        self.recipeTableView.dataSource = self
        self.recipeTableView.delegate = self
        
        let loadRecipesCompletionHandler: ([Recipe]) -> Void = {[weak self] (recipeArray:[Recipe]) -> Void  in
            //do something here
            print("here is my completion handler")
            
            for recipe in recipeArray{
                print("currentRecipe.id = \(recipe.id)")
                print("currentRecipe.title = \(recipe.title)")
            }
            
            self?.recipeArray = recipeArray
            self?.recipeTableView.reloadData()
        }
        
        NetworkingManager.loadRecipesWithCompletion(completionHandler:loadRecipesCompletionHandler)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //make sure the size of the title is the same every time the table view appears
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
        print("selectedRecipe = \(selectedRecipe.title)")
        
        let detailVC: RecipeDetailViewController = RecipeDetailViewController()
        detailVC.shownRecipe = selectedRecipe
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
