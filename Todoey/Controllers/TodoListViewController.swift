//
//  ViewController.swift
//  Todoey
//
//  Created by Seiji AMANO on 2019/01/29.
//  Copyright © 2019 Seiji AMANO. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        saveItems()
        // 選択したセルを反転表示させない
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //Mark: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        print("saveItems called")

        do {
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPrecidate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPrecidate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error detected fetching data from context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
}


//MARK - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        print(searchBar.text!)
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
