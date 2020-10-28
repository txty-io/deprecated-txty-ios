//
//  Downloader.swift
//  texterify-ios-sdk
//
//  Created by Lyn Almasri on 28.10.20.
//  Copyright © 2020 All About Apps. All rights reserved.
//

import Foundation

class Downloader {
    var baseUrl: String
    var projectId: String
    var exportConfigId: String
    var customBundleName = "TexterifyLocalization.bundle"
    
    init(baseUrl: String, projectId: String, exportConfigId: String) {
        self.baseUrl = baseUrl
        self.projectId = projectId
        self.exportConfigId = exportConfigId
    }
    
    func downloadLocalizationBundle() {
        let locale = Locale.current
        // TODO: build url, using test for now
        guard let url = URL(string: "") else {
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { _, _, _ in
        }
        task.resume()
    }
    
    func saveFile() {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        do {
            if Bundle(path: "\(documentDirectoryPath)/\(customBundleName)") == nil {
                let documentDirectoryUrl = URL(fileURLWithPath: documentDirectoryPath)
                try FileManager.default.createDirectory(at: documentDirectoryUrl.appendingPathComponent(customBundleName), withIntermediateDirectories: true, attributes: nil)
            }
        } catch let error as NSError {
            // TODO: Deal with error
            print(error.localizedDescription)
        }
    }
}
