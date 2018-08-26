//
//  FormControllerViewController.swift
//  Fuku
//
//  Created by Rahul Dua on 2018-08-25.
//  Copyright © 2018 Kushal Kumarasinghe. All rights reserved.
//
import UIKit
import Eureka
import ImageRow
class FormControllerViewController: FormViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        createLogInForm()
    }
    
    func createLogInForm() {
        form +++ SelectableSection<ListCheckRow<String>>("What would you like to add?", selectionType: .singleSelection(enableDeselection: true))
       
        <<< PickerRow<String>("Type") {
            $0.title = "ActionSheetRow"
          //  $0.selectorTitle = "What would you like to add?"
            $0.options = ["Tshirt", "Dress Shirt", "Blazer", "Jacket", "Dress", "Polo Tshirt", "Jeans", "Trousers", "Shorts", "Skirt", "Sandal", "Slipper", "Sneakers", "Dress shoes"]
            $0.value = "Tshirt"    // initially selected
           //print(form.values())
            
        }
       form +++ SelectableSection<ListCheckRow<String>>("What colour?", selectionType: .singleSelection(enableDeselection: true))
        
        <<< PickerRow<String>("Colour") {
            $0.title = "ActionSheetRow"
            //  $0.selectorTitle = "What would you like to add?"
            $0.options = ["Red", "Blue", "Black", "Grey", "White", "Yellow"]
            $0.value = "Red"    // initially selected
            
        }
        <<< ImageRow() { row in
            row.title = "Upload photo of clothing item"
            row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
            row.clearAction = .yes(style: UIAlertActionStyle.destructive)
        }
        <<< ButtonRow() {
            $0.title = "Confirm"
        }
            .onCellSelection { cell, row in
                print (self.form.values())
                
        self.performSegue(withIdentifier: "pathToHome", sender: self)
        }
        
        
        }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


