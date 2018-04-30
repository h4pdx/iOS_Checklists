//
//  ViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/28/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    /*
    let row0text = "Walk the dog"
    let row1text = "Brush my teeth"
    let row2text = "Learn iOS dev"
    let row3text = "Frisbee practice"
    let row4text = "Eat pizza 🍕"
    
    var row0checked = false
    var row1checked = false
    var row2checked = false
    var row3checked = false
    var row4checked = false
    */
    /*
    var row0item: ChecklistItem
    var row1item: ChecklistItem
    var row2item: ChecklistItem
    var row3item: ChecklistItem
    var row4item: ChecklistItem
    */
    
    var items: [ChecklistItem]
    
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
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            //var isChecked = false
            /*
            if indexPath.row == 0 {
                //row0checked = !row0checked
                //isChecked = row0checked
                //row0item.checked = !row0item.checked
                items[0].checked = !items[0].checked
            } else if indexPath.row == 1 {
                //row1checked = !row1checked
                //isChecked = row1checked
                row1item.checked = !row1item.checked
            } else if indexPath.row == 2 {
                //row2checked = !row2checked
                //isChecked = row2checked
                row2item.checked = !row2item.checked
            } else if indexPath.row == 3  {
                //row3checked = !row3checked
                //isChecked = row3checked
                row3item.checked = !row3item.checked
            } else if indexPath.row == 4 {
                //row4checked = !row4checked
                //isChecked = row4checked
                row4item.checked = !row4item.checked
            }
            */
            /*
            if isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            */
            
            /*
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            */
            
            let item = items[indexPath.row]
            //item.checked = !item.checked
            item.toggleChecked()
            //configureCheckmark(for: cell, at: indexPath)
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 5
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        //let label = cell.viewWithTag(1000) as! UILabel // still have no idea what the fuck this is for
        // moved to another func
        
        /*
        if indexPath.row % 5 == 0 {
            //label.text = "Walk the dog"
            //label.text = row0text
            label.text = row0item.text
        } else if indexPath.row % 5 == 1 {
            //label.text = "Brush my teeth"
            //label.text = row1text
            label.text = row1item.text
        } else if indexPath.row % 5 == 2 {
            //label.text = row2text
            label.text = row2item.text
        } else if indexPath.row % 5 == 3 {
            //label.text = row3text
            label.text = row3item.text
        } else if indexPath.row % 5 == 4 {
            //label.text = row4text
            label.text = row4item.text
        }
        */
        
        //label.text = item.text moved this to another func
        //configureCheckmark(for: cell, at: indexPath)
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // update checkmark icon based on underlying data
    //func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        //var isChecked = false
        /*
        if indexPath.row == 0 {
            //isChecked = row0checked
            isChecked = row0item.checked
        } else if indexPath.row == 1 {
            //isChecked = row1checked
            isChecked = row1item.checked
        } else if indexPath.row == 2 {
            //isChecked = row2checked
            isChecked = row2item.checked
        } else if indexPath.row == 3 {
            //isChecked = row3checked
            isChecked = row3item.checked
        } else if indexPath.row == 4 {
            //isChecked = row4checked
            isChecked = row4item.checked
        }
        */
        
        //let item = items[indexPath.row]
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    
    
    @IBAction func addItem() {
        let newRowIndex = items.count // returned number is the new index
        
        let item = ChecklistItem()
        item.text = "New row added."
        item.checked = false
        items.append(item)
        // update tableview
        let indexPath = IndexPath(row: newRowIndex, section: 0) // no sections in the table view, all are sec 0
        let indexPaths = [indexPath] // needs to be an array to insert into tableview
        tableView.insertRows(at: indexPaths, with: .automatic) // update table with changes to data structure
    }
    
    
}










