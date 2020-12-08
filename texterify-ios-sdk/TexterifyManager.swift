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
    public static var timeStamp = ""
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private var baseUrl = ""
    private var projectId = ""
    private var exportConfigId = ""
    private var complitionHandler: ((TexterifyError?) -> Void)?

    public init(baseUrl: String, projectId: String, exportConfigId: String) {
        self.baseUrl = baseUrl
        self.projectId = projectId
        self.exportConfigId = exportConfigId
    }

    public func getUpdatedStrings( complitionHandler: @escaping (TexterifyError?) -> Void) {
        self.complitionHandler = complitionHandler
        let downloader = Downloader(baseUrl: self.baseUrl, projectId: self.projectId, exportConfigId: self.exportConfigId)
        downloader.downloadLocalizationBundle(successCompletionHandler: parseData, errorCompletionHandler: complitionHandler)
    }

    func parseData() {
        guard let documentDirectory = documentDirectory else {
            return
        }
        let jsonFile = documentDirectory.appendingPathComponent("strings.json")
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: jsonFile)
            let jsonData = try decoder.decode(Model.self, from: data)
            TexterifyManager.timeStamp = jsonData.timestamp
            let defaults = UserDefaults.standard
            defaults.setValue(jsonData.timestamp, forKey: "texterify_timeStamp")
            self.createStringFiles(jsonData: jsonData)
        } catch {
            complitionHandler?(.decodingError)
        }
    }

    func createStringFiles(jsonData: Model) {
        do {
            guard let documentDirectory = documentDirectory else {
                return
            }
            // Create custom bundle if it does not exist
            if Bundle(path: "\(documentDirectory.path)/\(TexterifyManager.bundleName)") == nil {
                try FileManager.default.createDirectory(at: documentDirectory.appendingPathComponent(TexterifyManager.bundleName), withIntermediateDirectories: true, attributes: nil)
            }
    
            let localizationFolderURL = documentDirectory.appendingPathComponent(TexterifyManager.bundleName).appendingPathComponent(jsonData.data.languageCode + TexterifyManager.suffix)
            if !FileManager.default.fileExists(atPath: localizationFolderURL.path) {
                try FileManager.default.createDirectory(at: localizationFolderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let localizationFile = localizationFolderURL.appendingPathComponent("Localizable.strings")
            if FileManager.default.fileExists(atPath: localizationFile.path) {
                try FileManager.default.removeItem(at: localizationFile)
            }
            FileManager.default.createFile(atPath: localizationFile.path, contents: nil, attributes: nil)
            var stringChange = ""
            for pair in jsonData.data.texts {
                stringChange += "\"\(pair.key)\"=\"\(pair.value)\";\n"
            }
            try stringChange.write(to: localizationFile, atomically: true, encoding: .utf8)
        } catch {
            complitionHandler?(.errorWritingToFile)
        }
    }

    public static func localisedString(key: String, tableName: String?, comment: String) -> String {
        if let localizationBundle = Bundle(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(bundleName)") {
            return NSLocalizedString(key, tableName: nil, bundle: localizationBundle, value: "", comment: comment)
        } else {
            return NSLocalizedString(key, comment: comment)
        }
        
    }
}

public enum TexterifyError: Error {
    case decodingError
    case invalidURL
    case errorWritingToFile
    case downloadError
}
