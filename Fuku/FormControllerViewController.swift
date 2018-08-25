//
//  FormControllerViewController.swift
//  Fuku
//
//  Created by Rahul Dua on 2018-08-25.
//  Copyright © 2018 Kushal Kumarasinghe. All rights reserved.
//

import UIKit
import Eureka
class FormControllerViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ SelectableSection<ListCheckRow<String>>("What would you like to add?", selectionType: .singleSelection(enableDeselection: true))
        
        let inventory = ["Tops", "Bottoms", "Footwear"]
        for option in inventory {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.selectableValue = option
                listRow.value = nil
            }
        }
        
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
