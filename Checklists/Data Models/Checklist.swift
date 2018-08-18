//
//  Checklist.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/14/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]() // each checklist contains a array of checklist items
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        /*
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
        */
        //print("Checklist::countUncheckedItems()")
        return items.reduce(0) {cnt, item in cnt + (item.checked ? 0 : 1)} // functional programming
    }
    
    func sortChecklistItems() {
        print("checklist::sortChecklistItems()")
        items.sort(by: {
            item1, item2 in return item1.dueDate.compare(item2.dueDate) == .orderedAscending
        })
    }

}
