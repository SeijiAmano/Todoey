//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Seiji AMANO on 2019/02/14.
//  Copyright © 2019 Seiji AMANO. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            print(newCategory.name!)
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category" //XXX
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error detected fetching data from context: \(error)")
        }
        self.tableView.reloadData()
    }
    

}
