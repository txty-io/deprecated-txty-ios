import UIKit
import texterify_ios_sdk

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localizer = TexterifyManager(
            baseUrl: "app.texterify.com",
            projectId: "f2f0a0cb-3a56-4cc2-8e6a-38be2e6a7b38",
            exportConfigId: "8976d13d-f48e-4c8a-9105-69ace9adc4c4"
        )
        
        localizer.getUpdatedStrings(complitionHandler: { error in
            if error != nil {
                print(error!)
            }
        })
        
        print("🚀 " + TexterifyManager.localisedString(key: "hello_world", tableName: nil, comment: ""))
    }
}
