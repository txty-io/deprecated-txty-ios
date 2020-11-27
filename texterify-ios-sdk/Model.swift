//
//  Model.swift
//  texterify-ios-sdk
//
//  Created by Lyn Almasri on 29.10.20.
//  Copyright © 2020 All About Apps. All rights reserved.
//

import Foundation

class Model: Decodable {
    var data: DataObject
    var timestamp: String
}

class DataObject: Decodable {
    var countryCode: String
    var isDefault: Bool
    var languageCode: String
    var texts: [TextEntry]
    var plurals: [TextEntry]
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case isDefault = "is_default"
        case languageCode = "language_code"
        case texts
        case plurals
    }
}

class TextEntry: Decodable {
    var key: String
    var value: String
}
