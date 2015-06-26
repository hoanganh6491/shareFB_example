import Foundation
class FacebookShareService {
    private var shareImage : UIImage!
    private var shareDescription : String?
    
    init(image : UIImage, description : String?) {
        self.shareImage = image
        self.shareDescription = description
    }
    
    func start() {
        if FBSDKAccessToken.currentAccessToken() != nil && FBSDKAccessToken.currentAccessToken().permissions.contains("publish_actions"){
            self.startShareToFacebook()
        } else {
            getPublishPermission({ (error) -> () in
                let alert = UIAlertView(title: "Error!!!", message: error.domain, delegate: self, cancelButtonTitle: "Close")
                alert.show()
            }, success: { () -> () in
                self.startShareToFacebook()
            })
        }
    }
    
    private func startShareToFacebook() {
        var dict : NSMutableDictionary = NSMutableDictionary()
        if let des = self.shareDescription
        {
            dict.setValue(des, forKey: "caption")
            
        }
        dict.setValue(self.shareImage, forKey: "source")
        FBSDKGraphRequest(graphPath: "me/photos", parameters: dict as [NSObject : AnyObject], HTTPMethod: "POST").startWithCompletionHandler { (conn : FBSDKGraphRequestConnection!, response : AnyObject!, error :NSError!) -> Void in
            if error != nil {
                println("Can't use graphApi me/photos")
                let alert = UIAlertView(title: "Error!!!", message: error.domain, delegate: self, cancelButtonTitle: "Close")
                alert.show()
            } else {
                let alert = UIAlertView(title: "", message: "Successful!!!", delegate: self, cancelButtonTitle: "Close")
                alert.show()
            }
        }
    }
    
    private func getPublishPermission(fail : (error : NSError)->(),success:()->()) {
        var loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.Native
        loginManager.logInWithPublishPermissions(["publish_actions"], handler: { (loginResult:FBSDKLoginManagerLoginResult!, error :NSError!) -> Void in
            if error != nil {
                println("Can't login with permission public_action")
                fail(error: error)
            } else {
                if let result = loginResult {
                    if loginResult.isCancelled {
                        println("Can not get permisson")
                        fail(error: NSError(domain: "Can not get permisson", code: 100000, userInfo: nil))
                    } else {
                        if let permissions = loginResult.grantedPermissions {
                            if permissions.contains("publish_actions") {
                                success()
                            } else {
                                println("Publish actions is not allowed")
                                var error : NSError = NSError(domain: "Publish actions is not allowed", code: 1000, userInfo: nil)
                                fail(error : error)
                            }
                        } else {
                            println("Publish actions is not allowed")
                            var error : NSError = NSError(domain: "Publish actions is not allowed", code: 1000, userInfo: nil)
                            fail(error : error)
                        }
                    }
                    
                } else {
                    println("Can not get permisson")
                    fail(error: NSError(domain: "Can not get permisson", code: 100000, userInfo: nil))
                }
            }
        })

    }
}