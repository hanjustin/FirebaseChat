
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        _ = AuthManager.sharedInstance
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let signedIn = AuthManager.sharedInstance.hasSignedInUser
        let rootVC =
            signedIn ?
                UIStoryboard(name: "Contacts", bundle: nil).instantiateInitialViewController() :
                UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController()
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        return true
    }
}

