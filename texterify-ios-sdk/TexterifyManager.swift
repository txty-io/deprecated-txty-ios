//
//  TexterifyManager.swift
//  texterify-ios-sdk
//
//  Created by Lyn Almasri on 10.09.20.
//  Copyright © 2020 All About Apps. All rights reserved.
//

import Foundation

public class TexterifyManager {
    static let bundleName = "TexterifyLocalization.bundle"
    static let suffix = ".lproj"
    var baseUrl = ""
    var projectId = ""
    var exportConfigId = ""

    public init(baseUrl: String, projectId: String, exportConfigId: String) {
        self.baseUrl = baseUrl
        self.projectId = projectId
        self.exportConfigId = exportConfigId
    }
    
    public func getUpdatedStrings() {
        let downloader = Downloader(baseUrl: self.baseUrl, projectId: self.projectId, exportConfigId: self.exportConfigId)
        downloader.downloadLocalizationBundle(completion: self.constructStringFiles)
    }
    
    func constructStringFiles() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("strings.json")
        
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: jsonFile)
            let jsonData = try decoder.decode(Model.self, from: data)
            // Create custom bundle if it does not exist
            if Bundle(path: "\(documentDirectory.path)/\(TexterifyManager.bundleName)") == nil {
                try FileManager.default.createDirectory(at: documentDirectory.appendingPathComponent(TexterifyManager.bundleName), withIntermediateDirectories: true, attributes: nil)
            }
            let localizationFolderURL = documentDirectory.appendingPathComponent(TexterifyManager.bundleName).appendingPathComponent(jsonData.data.languageCode + TexterifyManager.suffix)
            if !FileManager.default.fileExists(atPath: localizationFolderURL.path) {
                try FileManager.default.createDirectory(at: localizationFolderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let localizationFile = localizationFolderURL.appendingPathComponent("Localization.strings")
            if FileManager.default.fileExists(atPath: localizationFile.path) {
                try FileManager.default.removeItem(at: localizationFile)
            }
            FileManager.default.createFile(atPath: localizationFile.path, contents: nil, attributes: nil)
            for pair in jsonData.data.texts {
                let stringChange = "\"\(pair.key)\":\"\(pair.value)\";"
                try stringChange.write(to: localizationFile, atomically: true, encoding: .utf8)
            }
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    // Use custom bundle for localised strings, fallback to main
    // find a shorter way?
    public static func localisedString(key: String, tableName: String?, comment: String) -> String {
        let localizationBundle = Bundle(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(bundleName)")
        return NSLocalizedString(key, tableName: nil, bundle: localizationBundle!, value: "", comment: "")
    }

}
