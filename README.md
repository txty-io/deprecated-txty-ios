# Texterify iOS sdk

[![Swift 5 ](https://img.shields.io/badge/Language-Swift%205-green)](https://developer.apple.com/swift)
[![SPM ](https://img.shields.io/badge/SPM-Compatible-orange)](https://swift.org/package-manager/)


The iOS SDK for Over-The-Air (OTA) translations with [Texterify] (https://github.com/chrztoph/texterify/). 


## Usage

In order to download new strings at app startup, in  `AppDelegate` create an instance of `TexterifyManager` and pass your Texterify project configurations in the parameters. After that call `getUpdatedStrings(complitionHandler:)`. 
```swift
func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let localizer = TexterifyManager(baseUrl: "https://texterify.mydomain.io",
                                     projectId: "my-project-id",
                                     exportConfigId: "my-export-config-id")
    localizer.getUpdatedStrings(complitionHandler: { _ in
        // handle error
    })
    return true
}
```

The SDK will download the new strings for the app's current language and region settings, and it will create new `Localizable.strings` files. All the UI elements that are loaded after the download is done will show the changes immediately or after app restart.

To use the new strings, use:
```swift
TexterifyManager.localisedString(key: "key", tableName: nil, comment: "")
```

## Version Compatibility

Current Swift compatibility breakdown:

| Swift Version | Framework Version |
| ------------- | ----------------- |
| 5.x           | 0.x               |


## Installation

### Swift Package Manager (Recommended)

Add the following dependency to your `Package.swift` file:

```
.package(url: "https://github.com/texterify/texterify-ios", from: "0.0.6")
```

### Manually

Just drag and drop the `.swift` files in the `texterify-ios-sdk` folder into your project.


