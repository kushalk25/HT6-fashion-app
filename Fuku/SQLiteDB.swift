//
//  SQLiteDB.swift
//  Fuku
//
//  Created by Kushal Kumarasinghe on 2018-08-24.
//  Copyright © 2018 Kushal Kumarasinghe. All rights reserved.
//

import Foundation

import SQLite

class SQLiteDB {
    static let instance = SQLiteDB()
    private let db: Connection?
    
    // Clothing Table
    private let clothingTable = Table("clothing")
    private let clothingId = Expression<Int>("id")
    private let clothingName = Expression<String>("name")
    private let clothingType = Expression<String>("type")
    private let clothingColour = Expression<String>("colour")
    
    // flags
    private let deleteClothingTable = false
    

    private init(){
        print("made the db")
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print("db found")
            createClothingTable()
        } catch {
            db = nil
            print("unable to find db")
        }
            
    }
    
    
    private func createClothingTable() {
    
        do {
            if (deleteClothingTable) {
                try db?.run(clothingTable.drop(ifExists: true))
            }
            
            try db!.run(clothingTable.create(ifNotExists: true) { table in
                table.column(clothingId, primaryKey: true)
                table.column(clothingName)
                table.column(clothingType)
                table.column(clothingColour)
            })
            
        } catch {
            print("could not create clothing table")
        }
    }
    
    func getClothing() {
        do {
            for clothing in try db!.prepare(clothingTable) {
                print("id: \(clothing[clothingId]), name: \(clothing[clothingName]), colour: \(clothing[clothingColour]), type: \(clothing[clothingType]) ")
            }
        } catch {
            print("failed to get cloting")
        }
    }
    
    func addClothing(name: String, colour: String, type: String) {
        
        do {
            let insert = clothingTable.insert(clothingName <- name, clothingColour <- colour, clothingType <- type)
            let rowid = try db!.run(insert)
            // get rid of rowid if i don't need it
        } catch {
            print("cannot add clothing: \(name)")
        }
    }

    func alive() {
        print("I'm alive")
    }
}
