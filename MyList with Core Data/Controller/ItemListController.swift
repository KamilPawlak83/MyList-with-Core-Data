//
//  ItemListController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 28/09/2021.
//

import UIKit
import CoreData

class ItemListController: SwipeCellKitController {

    var itemList = [Item]()
    
    // when the category in MyList was pressed - load list with items.
    var categoryPressed : Category? {
        didSet{
            loadItems()
            title = categoryPressed?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - TableView Section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // We inherit cell from SwipeCellKitController and override it
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].name
        
        // This is a Ternary Operation
        cell.accessoryType = itemList[indexPath.row].checkmark == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We change the state to the opposite (.checkmark or .none)
        itemList[indexPath.row].checkmark = !itemList[indexPath.row].checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
 
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Type something"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak ac] _ in
            let newItem = Item(context: self.context)
            newItem.checkmark = false
            newItem.parentRelationship = self.categoryPressed
            newItem.name = ac?.textFields?[0].text ?? "New Item"
            self.itemList.append(newItem)
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    //MARK: - Save Items
    
    override func saveItems() {
        super.saveItems()
        tableView.reloadData()
    }
    
    //MARK: - Load Items
    // Item.fetchRequest() is a default value in this case
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentRelationship.title matchEs %@", categoryPressed!.title!)
        
        if let secondPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, secondPredicate] )
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    //MARK: - Delete Items
    
    override func updateData(at indexPath: IndexPath) {
        self.context.delete(self.itemList[indexPath.row])
        self.itemList.remove(at: indexPath.row)
        self.saveItems()
    }
}

//MARK: - SearchBar Section
extension ItemListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
   // We back to main state before we search something
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
