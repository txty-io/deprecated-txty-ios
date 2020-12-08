//
//  ViewController.swift
//  Example
//
//  Created by Lyn Almasri on 10.09.20.
//  Copyright © 2020 All About Apps. All rights reserved.
//

import UIKit
import texterify_ios_sdk

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localizer = TexterifyManager(baseUrl: "texterify.allaboutapps.at", projectId: "8310ce77-652e-4c1a-b866-0b2234f60b53", exportConfigId: "876165dc-c1f7-4a84-bb5e-b3adc28d3aea")
        localizer.getUpdatedStrings(complitionHandler: { error in
            if error != nil {
                print(error)
            }        })
        print(TexterifyManager.localisedString(key: "hello", tableName: nil, comment: ""))
        
    }
    
}
