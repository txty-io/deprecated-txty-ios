//
//  TexterifyManager.swift
//  texterify-ios-sdk
//
//  Created by Lyn Almasri on 10.09.20.
//  Copyright © 2020 All About Apps. All rights reserved.
//

import Foundation

public class TexterifyManager {
    public static var shared = TexterifyManager()
    static let bundleName = "TexterifyLocalization.bundle"
    static let suffix = ".lproj"
    static var baseUrl = ""
    static var projectId = ""
    static var exportConfigId = ""
    
    // Derprecated: Copy files from main.bundle
    public func copyLocalisationFiles() {
        do {
            let localisationDirectorys = try FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath).filter { $0.contains(TexterifyManager.suffix) }
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if Bundle(path: "\(documentDirectoryPath)/\(TexterifyManager.bundleName)") == nil {
                let documentDirectoryUrl = URL(fileURLWithPath: documentDirectoryPath)
                try FileManager.default.createDirectory(at: documentDirectoryUrl.appendingPathComponent(TexterifyManager.bundleName), withIntermediateDirectories: true, attributes: nil)
            }
            for directory in localisationDirectorys {
                try FileManager.default.copyItem(atPath: Bundle.main.bundlePath + "/" + directory, toPath: documentDirectoryPath + "/\(TexterifyManager.bundleName)/" + directory)
            }
            
        } catch let error as NSError {
            // TODO: Deal with error
            print(error.localizedDescription)
        }
    }
    
    // Use custom bundle for localised strings, fallback to main
    // find a shorter way?
    public static func localisedString(key: String, tableName: String?, comment: String) -> String {
        let localizationBundle = Bundle(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(bundleName)")
        return NSLocalizedString(key, tableName: nil, bundle: localizationBundle!, value: "", comment: "")
    }
    
    // TODO: Update files
    // Derprecated: Using test json
//    func updateFiles(stringChanges: [StringChange]) {
//        let documentDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(TexterifyManager.bundleName)/" + "/en.lproj/Localizable.strings"
//        var dict = NSMutableDictionary(contentsOfFile: path)
//        for change in stringChanges {
//            print(change.key)
//            if dict?[change.key] != nil {
//                dict?.setValue(change.value, forKey: change.key)
//            }
//        }
//        let string = dict?.descriptionInStringsFileFormat
//        try? string?.write(to: documentDir.appendingPathComponent(TexterifyManager.bundleName).appendingPathComponent("en.lproj").appendingPathComponent("/Localizable.strings"), atomically: true, encoding: .utf8)
//    }
}
