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
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        super.init()
    }

    func toggleChecked() {
        checked = !checked // swaps either way
    }
}
