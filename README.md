# Texterify iOS sdk


iOS SDK for Over-The-Air (OTA) translation translations with Texterify. 


## Usage

Create an instance of  `TexterifyManager` and pass your Texterify configurations in the parameters. Call `getUpdatedStrings` at app startup or anywhere in your code. The SDK will download the new strings files and they can be accessed using `localisedString(key: String, tableName: String?, comment: String)`.   


## Version Compatibility

Current Swift compatibility breakdown:

| Swift Version | Framework Version |
| ------------- | ----------------- |
| 5.x           | 1.x               |


## Installation

### Swift Package Manager (Recommended)

<!-- todo -->

### Manually

Just drag and drop the `.swift` files in the `texterify-ios-sdk` folder into your project.


