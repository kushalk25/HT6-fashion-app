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
    
    

    private init(){
        print("made the db")
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print("db found")
            print(path)
        } catch {
            db = nil
            print("unable to find db")
        }
            
    }

    func alive() {
        print("I'm alive")
    }
}
