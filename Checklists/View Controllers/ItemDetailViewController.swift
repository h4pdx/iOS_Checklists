//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/30/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
            title = "Edit Item" // Change title
            textField.text = item.text
            doneBarButton.isEnabled = true // enable done button if we are editing
        }
    }
    
    // ensure the single input field does not turn grey when tapped - looks funny
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func cancel() {
        //navigationController?.popViewController(animated: true)
        delegate?.itemDetailViewControllerDidCancel(self) // pass to ChecklistVC object
    }
    
    // add or edit newly typed text
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            //item.text = textField.text!
            //item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item) // pass to ChecklistVC object
        }
    }
    
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
    

}
