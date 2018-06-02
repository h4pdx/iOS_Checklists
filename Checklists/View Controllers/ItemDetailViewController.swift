//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/30/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    weak var delegate: ItemDetailViewControllerDelegate?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
            title = "Edit Item" // Change title
            textField.text = item.text
            doneBarButton.isEnabled = true // enable done button if we are editing
            
            shouldRemindSwitch.isOn = item.shouldRemind // set switch to on or off depending on item (off for new items)
            dueDate = item.dueDate // get dueDate from ChecklistItem
        }
        updateDueDateLabel()
    }
    
    //MARK:- Table view delegates
    
    // ensure the single input field does not turn grey when tapped - looks funny
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath // section 1, row 1 is the Due Date cell
        } else {
            return nil // only the Due Date cell is selectable
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // check to see if the cellForRowAt is being called with the indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath) // othwise pass to TableView data source
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3 // if date picker is visible, section1  will have 3 rows
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section) // othwise go thru to original data source
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217 // set size for date picker cell, 216 + 1 for seperator line
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder() // hides on-screen keyboard if it was visible
        
        // if user taps Due Date label row, show or hide the date picker
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker() // show date picker if not visible when Due Date tapped
            } else {
                hideDatePicker() // hide date picker if visible when Due Date tapped
            }
        }
    }
    
    // app will crash without this override too
    // overriding data souce for static table view csan get tricky,
    // table view normally doesn't know about section 1, row 2: date picker is outside normal table view (storyboard)
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        // 'trick' data source that there are really 3 ropws when date picker is visible
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    //MARK:- IBAction outlets
    
    @IBAction func cancel() {
        //navigationController?.popViewController(animated: true)
        delegate?.itemDetailViewControllerDidCancel(self) // pass to ChecklistVC object
    }
    
    // add or edit newly typed text
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()

            delegate?.itemDetailViewController(self, didFinishAdding: item) // pass to ChecklistVC object
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                // do nothing
            }
        }
    }
    
    //MARK:- class methods
    
    // ensure keyboard comes up right away
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // steps in when view is first rendered
        textField.becomeFirstResponder() // giving the control focus to the text field
    }
    
    // UITextField deleagte method, invoked every time the user changes the text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // first figure out what new text will be
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)! // convert from Obj-C NSRange object
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter() // format Date object
        formatter.dateStyle = .medium // give the date a style
        formatter.timeStyle = .short //  give the time a seperate style
        dueDateLabel.text = formatter.string(from: dueDate) // convert to string for label
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1) // Due Date cell
        let indexPathDatePicker = IndexPath(row: 2, section: 1) // Date Picker wheel cell
        // set textColor of the row to the tint color
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none) // reload thr Due Date row
        tableView.endUpdates() // wrapped in begin/end updates so the 2 operations are performed at the same time
        
        datePicker.setDate(dueDate, animated: false) // date picker starts at previously selected date, not current
    }

    // opposite of showDatePicker
    // eeded bc app will crash when Due Date is tapped while Date picker is visible
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1) // Due Date row
            let indexPathDatePicker = IndexPath(row: 2, section: 1) // row to be deleted
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor.black // change color back to black, from tint color
            }
            
            tableView.beginUpdates() // wrap in begin/end updates again so animations are handled at same time
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade) // delete extra date picker wheel row
            tableView.endUpdates()
        }
    }
    
    // Prevent Date Picker and keyboard overlap
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    
}
