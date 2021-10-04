//
//  MyListController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 01/10/2021.
//

import UIKit
import CoreData
import SwipeCellKit


class MyListController: UITableViewController {

    var myList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
       
        tableView.rowHeight = 65.0
    }

    // MARK: - TableView Section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myList.count
    }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = myList[indexPath.row].title
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We can have more than 1 segue. In this case we have only one
        if segue.identifier == "goToItems" {
                let destinationVC = segue.destination as! ItemListController
               
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.categoryPressed = myList[indexPath.row]
            }
                
            }
        }
       
   
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add new list", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Type something"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak ac] _ in
            let newItem = Category(context: self.context)
            
            newItem.title = ac?.textFields?[0].text ?? "New Item"
            self.myList.append(newItem)
            
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
        
    //MARK: - Save Items
    
    func saveItems() {
        
        do {
        try context.save()
        } catch {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Load Items
    // Item.fetchRequest() is a default value in this case
    func loadItems() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            myList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}
//MARK: - Swipe Cell Delegate Section

extension MyListController: SwipeTableViewCellDelegate {
     
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.context.delete(self.myList[indexPath.row])
                self.myList.remove(at: indexPath.row)
                
                self.saveItems()
            }
            // Here is our "Trash" icon
            deleteAction.image = UIImage(named: "Trash")

            return [deleteAction]
    }
    
    // This is animaton for delete action
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}
