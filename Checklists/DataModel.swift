//
//  DataModel.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/15/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    
    
    // file:// URL
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array.")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath() // get results of file path
        // try? returns nil if no object - alternative to do-catch blocks
        if let data = try? Data(contentsOf: path) { // try to load contents of Checklists.plists
            let decoder = PropertyListDecoder() // create decoder instance
            do {
                lists = try decoder.decode([Checklist].self, from: data) // load array of Checklists into lists array
            } catch {
                print("Error decoding item array.")
            }
        }
    }

    
}
