//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/29/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    func toggleChecked() {
        checked = !checked // swaps either way
    }
}
