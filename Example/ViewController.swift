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
//        TexterifyManager.shared.copyLocalisationFiles() 2020-10-28T09:41:32Z
//        TexterifyManager.shared.getUpdatedString()
//        let locale = String(Locale.preferredLanguages.first?.description ?? "")
//        let locale = String(Locale.current.description ?? "")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//        let timeStamp = dateFormatter.string(from: Date())
//        let baseUrl = "texterify.allaboutapps.at"
//        let projectId = "8310ce77-652e-4c1a-b866-0b2234f60b53"
//        let exportConfigId = "bf14063e-cbae-4b30-9a6e-b2a4e1a9170e"
//
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = baseUrl
//        components.path = "/api/v1/projects/\(projectId)/export_configs/\(exportConfigId)/release"
//        components.queryItems = [
//            URLQueryItem(name: "locale", value: "\(locale)"),
//            URLQueryItem(name: "timestamp", value: timeStamp)
//        ]
//        print(components.url)
        
        let localizer = TexterifyManager(baseUrl: "texterify.allaboutapps.at", projectId: "8310ce77-652e-4c1a-b866-0b2234f60b53", exportConfigId: "bf14063e-cbae-4b30-9a6e-b2a4e1a9170e")
        localizer.getUpdatedStrings()
        
    }
    
}
