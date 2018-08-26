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
    private let clothingId = Expression<Int64>("id")
    private let clothingName = Expression<String>("name")
    private let clothingColour = Expression<String>("colour")
    
    // Type Table
    private let typeTable = Table("type")
    private let typeId = Expression<Int64>("id")
    private let typeName = Expression<String>("name")
    private let typeParentId = Expression<Int64?>("parent_id")
    
    // Clothing_Type Table
    private let clothing_typeTable = Table("clothing_type")
    private let CT_clothingId = Expression<Int64>("clothing_id")
    private let CT_typeId = Expression<Int64>("type_id")
    
    // flags
    private let deleteClothingTable = false
    private let deleteTypeTable = true
    private let deleteClothing_TypeTable = false
    

    private init(){
        print("made the db")
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print("db found")
            createClothingTable()
            createTypeTable()
            createClothing_TypeTable()
        } catch {
            db = nil
            print("unable to find db")
        }
            
    }
    
    // Clothing Table functions
    private func createClothingTable() {
    
        do {
            if (deleteClothingTable) {
                try db?.run(clothingTable.drop(ifExists: true))
            }
            
            try db!.run(clothingTable.create(ifNotExists: true) { table in
                table.column(clothingId, primaryKey: true)
                table.column(clothingName)
                table.column(clothingColour)
            })
            
        } catch {
            print("could not create clothing table")
        }
    }
    
    func getClothing() {
        do {
            for clothing in try db!.prepare(clothingTable) {
                print("id: \(clothing[clothingId]), name: \(clothing[clothingName]), colour: \(clothing[clothingColour]) ")
            }
        } catch {
            print("failed to get cloting")
        }
    }
    
    func getClothingByType(name: String) -> [String] {
        var clothingResult: [String] = []
        
        do {
            
            var type_id: Int64? = nil
            var clothing_ids: [Int64] = []
            
            
            for typeObj in try db!.prepare(typeTable.filter(typeName == name)) {
                type_id = typeObj[typeId]
            }
            
            
            for clothing_type in try db!.prepare(clothing_typeTable.filter(CT_typeId == type_id!)) {
                clothing_ids.append(clothing_type[CT_clothingId])
            }

            
            for clothing_id in clothing_ids {
            
                for clothing in try db!.prepare(clothingTable.filter(clothingId == clothing_id)) {
                    print("id: \(clothing[clothingId]), name: \(clothing[clothingName]), colour: \(clothing[clothingColour]) ")
                    clothingResult.append(clothing[clothingName])
                }
            }
        } catch {
            print("failed to get cloting")
        }
        
        return clothingResult
    }
    
    func addClothing(name: String, colour: String, types: [String]) {
        
        do {
            let insertClothing = clothingTable.insert(clothingName <- name, clothingColour <- colour)
            let clothingId = try db!.run(insertClothing)
            for type in types {
                
                let typeId = getTypeIdByName(name: type)
                
                let insertClothing_Type = clothing_typeTable.insert(
                    CT_clothingId <- clothingId,
                    CT_typeId <- typeId!
                )
                try db!.run(insertClothing_Type)
    
            }
        } catch {
            print("cannot add clothing: \(name)")
            print("error \(error)")
        }
    }

    // Type Table functions
    private func createTypeTable() {
        
        do {
            if (deleteTypeTable) {
                try db?.run(typeTable.drop(ifExists: true))
            }
            
            try db!.run(typeTable.create(ifNotExists: true) { table in
                table.column(typeId, primaryKey: true)
                table.column(typeName, unique: true)
                table.column(typeParentId)
            })
            
            if(deleteTypeTable){
                let upperwear_id = try db!.run(typeTable.insert(typeName <- "upperwear", typeParentId <- nil))
                let lowerwear_id = try db!.run(typeTable.insert(typeName <- "lowerwear", typeParentId <- nil))
                let footwear_id = try db!.run(typeTable.insert(typeName <- "footwear", typeParentId <- nil))
                
                try db!.run(typeTable.insert(typeName <- "jacket", typeParentId <- upperwear_id))
                let tops_id = try db!.run(typeTable.insert(typeName <- "tops", typeParentId <- upperwear_id))
                try db!.run(typeTable.insert(typeName <- "t-shirt", typeParentId <- tops_id))
                try db!.run(typeTable.insert(typeName <- "dress shirt", typeParentId <- tops_id))
                
                try db!.run(typeTable.insert(typeName <- "jeans", typeParentId <- lowerwear_id))
                try db!.run(typeTable.insert(typeName <- "sweat pants", typeParentId <- lowerwear_id))
                
                try db!.run(typeTable.insert(typeName <- "sneakers", typeParentId <- footwear_id))
                try db!.run(typeTable.insert(typeName <- "boots", typeParentId <- footwear_id))
            }
        } catch {
            print("could not create clothing table")
        }
    }
    
    func getTypes() -> [String] {
        var types: [String] = []
        do {
            print("printing types")
            for type in try db!.prepare(typeTable) {
                print("id: \(type[typeId]), name: \(type[typeName]), parent: \(type[typeParentId]) ")
                types.append(type[typeName])
            }
        } catch {
            print("failed to get types")
        }
        print("returning types: \(types)")
        return types
    }
    
    func getTypeIdByName(name: String) -> Int64? {
        
        var resultId: Int64? = nil
        do {
            for type in try db!.prepare(typeTable.filter(typeName == name)) {
                print("id: \(type[typeId]), name: \(type[typeName]), parent: \(type[typeParentId]) ")
                resultId = type[typeId]
            }
        } catch {
            print("failed to get type id for /(name)")
        }
        return resultId
    }
    
    // Clothing Type Relational DB functions
    
    private func createClothing_TypeTable() {
        
        do {
            if (deleteClothing_TypeTable) {
                try db?.run(clothing_typeTable.drop(ifExists: true))
            }
            
            try db!.run(clothing_typeTable.create(ifNotExists: true) { table in
                table.column(CT_clothingId)
                table.column(CT_typeId)
                table.unique(CT_clothingId, CT_typeId)
            })
            
        } catch {
            print("could not create clothing type relational table")
        }
    }
    
    func getClothing_Types(){
        do {
            for clothing_type in try db!.prepare(clothing_typeTable) {
                print("type: \(clothing_type[CT_typeId]), clothing: \(clothing_type[CT_clothingId])")
            }
        } catch {
            print("could not show relational table")
        }
    }
    
    
    func alive() {
        print("I'm alive")
    }
}
