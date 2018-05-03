//
//  ViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/28/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items: [ChecklistItem] // array of checklist items
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Walk the cat"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Frisbee practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat pizza 🍕"
        row4item.checked = true
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "Give my nugget a kiss"
        row5item.checked = false
        items.append(row5item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**********************************************************************************************************************
     ItemDetailVC protocol implementations
     */
    // implemented delegates for AddItemVC - cancel
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // implemented delgates for AddItemVC Protocol - done + add to list
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count // get cell index
        items.append(item) // add new CheckListItem to array
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // no sections in the table view, all are sec 0
        let indexPaths = [indexPath] // needs to be an array to insert into tableview
        tableView.insertRows(at: indexPaths, with: .automatic) // update table with changes to data structure
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) { // uses equality property of NSObject to match objects (could probably overload == instead)
            let indexPath = IndexPath(row: index, section: 0) // match with index path from table view
            if let cell = tableView.cellForRow(at: indexPath) { // grab the valid cell at our IndexPath
                configureText(for: cell, with: item) // update text field with edited text
            }
        }
        navigationController?.popViewController(animated: true)
    }
    /**********************************************************************************************************************/

    // this method is called after the new view controller has been loaded, and BEFORE it appears on-screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "AddItem" needs to be added to the segue identifier for this to work
        if (segue.identifier == "AddItem") { // specify the correct segue (could be more than one, depending on app)
            // new controller to be displayed is sotred in segue.destination
            let controller = segue.destination as! ItemDetailViewController // downcast UIViewController obj to AddViewVC object
            controller.delegate = self // sets AddItemVC's delegate property to ChecklistVC
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // find tthe table view row number by looking up the corresponding index path
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    /**********************************************************************************************************************
     Table View Delegates
     */

    // pass data about slecetd table cell to underlying data structure
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // see if we have a valid cell at this row
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row] // initialize pointer to the ChecklistItem at this particular index
            item.toggleChecked() // toggle checkmark (checked/unchecked)
            configureCheckmark(for: cell, with: item) // update cell with toggled checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true) // update table
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // number of items currently in data structure
    }
    
    // updates full checklist line with new data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) // updates
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // delete a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // table view tells us what cell we are deleting
        // update cell (in this case delete it)
        let indexPaths = [indexPath] // tableView protocols require an Array object, even if its just one
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /**********************************************************************************************************************/
    
    // update table view label with data structure string
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // update checkmark icon based on underlying data
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if (item.checked) {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
    }
   
    
}










