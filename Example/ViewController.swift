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
        
        let localizer = TexterifyManager(baseUrl: "texterify.allaboutapps.at", projectId: "c757a671-4747-4d20-b2ed-7f76149725df", exportConfigId: "d21a01e2-87ee-4b1e-ba0a-d5a46623c3e7")
        localizer.getUpdatedStrings(complitionHandler: { error in
            if error != nil {
                print(error)
            }        })
        print(TexterifyManager.localisedString(key: "hello", tableName: nil, comment: ""))
        
    }
    
}
