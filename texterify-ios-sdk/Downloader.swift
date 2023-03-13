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

    func downloadLocalizationBundle(successCompletionHandler:@escaping() -> Void, errorCompletionHandler: @escaping (TexterifyError?) -> Void) {
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
        
        if let timestamp = userDefault.string(forKey: "texterify_timestamp") {
            components.queryItems?.append(URLQueryItem(name: "timestamp", value: timestamp))
        }

        guard let url = components.url else {
            errorCompletionHandler(.invalidURL)
            return
        }
        
        print("🌍 texterify-ios-sdk: fetching latest translations from", url)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("🌍 texterify-ios-sdk: download initializing", "baseUrL: " + baseUrl, "projectId: " + projectId, "exportConfigId: " + exportConfigId)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if (error != nil) {
                print("🌍 texterify-ios-sdk: could not download new strings")
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
                        print("🌍 texterify-ios-sdk: could not write to file")
                        errorCompletionHandler(.errorWritingToFile)
                    }
                }
            } else {
                if let response = response as? HTTPURLResponse, response.statusCode == 304 {
                    print("🌍 texterify-ios-sdk: latest strings already downloaded, nothing to do")
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    print("🌍 texterify-ios-sdk: could not download new strings", "statusCode: " + (statusCode != nil ? String(statusCode!) : "unknown status code"))
                }
            }
        })
        task.resume()
    }
}
