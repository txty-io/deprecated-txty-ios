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
    static let dateFormatter = DateFormatter()

    init(baseUrl: String, projectId: String, exportConfigId: String) {
        self.baseUrl = baseUrl
        self.projectId = projectId
        self.exportConfigId = exportConfigId
        Downloader.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }

    func downloadLocalizationBundle(successCompletionHandler:@escaping() -> (), errorCompletionHandler: @escaping (TexterifyError?) -> Void) {
        guard let appLanguageCode = Locale.current.languageCode, let regionCode = Locale.current.regionCode else {
            return
        }
        let locale = "\(appLanguageCode)-\(regionCode)"
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = "/api/v1/projects/\(projectId)/export_configs/\(exportConfigId)/release"
        components.queryItems = [
            URLQueryItem(name: "locale", value: "\(locale)")
        ]
        let userDefault = UserDefaults.standard
//        if let timeStamp = userDefault.string(forKey: "texterify_timeStamp") {
//            components.queryItems?.append(URLQueryItem(name: "timestamp", value: timeStamp))
//        }

        guard let url = components.url else {
            errorCompletionHandler(.invalidURL)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                errorCompletionHandler(.downloadError)
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let finalFile = documentsUrl.appendingPathComponent("strings.json")
                let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
                if let _ = try? data.write(to: destinationUrl) {
                    do {
                        if FileManager.default.fileExists(atPath: finalFile.path) {
                            try FileManager.default.removeItem(at: finalFile)
                        }
                        try FileManager.default.moveItem(at: destinationUrl, to: finalFile)
                        successCompletionHandler()
                    } catch {
                        errorCompletionHandler(.errorWritingToFile)
                    }
                }
            }
        })
        task.resume()
    }
}
