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
    static var dateFormatter = DateFormatter()
    
    init(baseUrl: String, projectId: String, exportConfigId: String) {
        self.baseUrl = baseUrl
        self.projectId = projectId
        self.exportConfigId = exportConfigId
    }
    
    func downloadLocalizationBundle(completion: @escaping () -> Void) {
        let locale = String(Locale.preferredLanguages.first?.description ?? "")
        Downloader.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let timeStamp = Downloader.dateFormatter.string(from: Date())
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = "/api/v1/projects/\(projectId)/export_configs/\(exportConfigId)/release"
        components.queryItems = [
            URLQueryItem(name: "locale", value: "\(locale)"),
//            URLQueryItem(name: "timestamp", value: timeStamp)
        ]
        
        guard let url = components.url else {
            print("Invalid URL")
            return
        }
        print(url)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print("There was an error downloading the file: \(error.localizedDescription)\n")
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let finalFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("strings.json")

                let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
                if let _ = try? data.write(to: destinationUrl) {
                    do {
                        if FileManager.default.fileExists(atPath: finalFile.path) {
                            try FileManager.default.removeItem(at: finalFile)
                        }
                        try FileManager.default.copyItem(at: destinationUrl, to: finalFile)
                        try FileManager.default.removeItem(at: destinationUrl)
                        completion()
                    } catch {
                        print("there was an error")
                    }
                }
            }
        })
        task.resume()
    }
}
