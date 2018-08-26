 //
//  WardrobeViewController.swift
//  Fuku
//
//  Created by Kushal Kumarasinghe on 2018-08-25.
//  Copyright © 2018 Kushal Kumarasinghe. All rights reserved.
//

import UIKit

class WardrobeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var clothingTypes: [String] = []
    var selected = ""
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingTypes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = clothingTypes[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(clothingTypes[indexPath.row])
        selected = clothingTypes[indexPath.row]
        self.performSegue(withIdentifier: "segueToWardrobeItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWardrobeItem" {
            if let destination = segue.destination as? WardrobeItemViewController {
                
                destination.clothes = SQLiteDB.instance.getClothingByType(name: self.selected)
                
                // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothingTypes = SQLiteDB.instance.getTypes()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
