//
//  SwipeCellKitController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 04/10/2021.
//

import UIKit
import SwipeCellKit

class SwipeCellKitController: UITableViewController, SwipeTableViewCellDelegate {
    
    // context is a part of Core Data syntax
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65.0
    }
    
    // MARK: - TableView Section

    // We create Swipable Cell foundation (both controllers inherits from this class)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    cell.delegate = self
    return cell
}
    
    //MARK: - SwipeCellKit Section
    
    //This method is from package dependency: SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            self.updateData(at: indexPath)
        }
        // Here is our "Trash" icon
        deleteAction.image = UIImage(named: "Trash")
        return [deleteAction]
    }

    // We override this method in proper VC
    func updateData (at indexPath: IndexPath) {
        //Update our data
    }
    
    // I add this method to keep code more DRY
    func saveItems() {
        do {
        try context.save()
        } catch {
            print("Saving error: \(error)")
        }
    }
    
}
