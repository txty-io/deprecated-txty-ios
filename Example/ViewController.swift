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
        
        let localizer = TexterifyManager(baseUrl: "texterify.allaboutapps.at", projectId: "8310ce77-652e-4c1a-b866-0b2234f60b53", exportConfigId: "bf14063e-cbae-4b30-9a6e-b2a4e1a9170e")
        localizer.getUpdatedStrings()
        
    }
    
}
