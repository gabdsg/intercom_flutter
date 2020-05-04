import UIKit
import Intercom

var unreadOberver: Any?

class UnreadStreamHandler: NSObject, FlutterStreamHandler {
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        unreadOberver = NotificationCenter.default.addObserver(forName: NSNotification.Name.IntercomUnreadConversationCountDidChange, object: nil, queue: OperationQueue.main, using: { note in
            let myNum = NSNumber(value: Intercom.unreadConversationCount())
            events(myNum)
        })
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let unreadOberver = unreadOberver {
            NotificationCenter.default.removeObserver(unreadOberver)
        }
        return nil
    }
}

public class SwiftIntercomFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftIntercomFlutterPlugin()
        let channel = FlutterMethodChannel(name: "gabdsg.io/intercom", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let unreadChannel = FlutterEventChannel(name: "gabdsg.io/intercom/unread", binaryMessenger: registrar.messenger())
        let unreadStreamHandler = UnreadStreamHandler()
        unreadChannel.setStreamHandler(unreadStreamHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let args = call.arguments as? [String: Any] ?? [:]
        
        switch call.method {
        case "initialize":
            let iosApiKey = args["iosApiKey"] as! String
            let appId = args["appId"] as! String
            Intercom.setApiKey(iosApiKey, forAppId: appId)
            result("Initialized Intercom")
        case "registerUnidentifiedUser":
            Intercom.registerUnidentifiedUser()
            result("Registered unidentified user")
        case "setUserHash":
            let userHash = args["userHash"] as! String
            Intercom.setUserHash(userHash)
            result("User hash added")
        case "registerIdentifiedUserWithUserId":
            let userId = args["userId"] as! String
            Intercom.registerUser(withUserId: userId)
            result("Registered user")
        case "registerIdentifiedUserWithEmail":
            let email = args["email"] as! String
            Intercom.registerUser(withEmail: email)
            result("Registered user")
        case "setLauncherVisibility":
            if let visibility = args["visibility"] as? String{
                Intercom.setLauncherVisible( ("VISIBLE" == visibility) )
                result("Setting launcher visibility")
            }
        case "unreadConversationCount":
            let count = Intercom.unreadConversationCount()
            result(NSNumber(value: count))
        case "displayMessenger":
            Intercom.presentMessenger()
            result("Presented messenger")
        case "hideMessenger":
            Intercom.hideMessenger()
            result("Messenger hidden")
        case "displayHelpCenter":
            Intercom.presentHelpCenter()
            result("Presented help center")
        case "updateUser":
            let attributes = ICMUserAttributes()
            if let email = args["email"] as? String{
                attributes.email = email
            }
            
            if let name = args["name"] as? String{
                attributes.name = name
            }
            
            if let phone = args["phone"] as? String {
                attributes.phone = phone
            }
            if let userId = args["userId"] as? String {
                attributes.userId = userId
            }
            
            if let companyName = args["company"] as? String, let companyId = args["companyId"] as? String{
                let company = ICMCompany()
                company.name = companyName
                company.companyId = companyId
                attributes.companies = [company]
            }
            
            if let customAttributes = args["customAttributes"] as? [String : Any]{
                attributes.customAttributes = customAttributes
            }
            Intercom.updateUser(attributes)
            result("Updated user")
        case "logout":
            Intercom.logout()
            result("Logged out")
        case "logEvent":
            if let name = args["name"] as? String{
                if let metaData = args["metaData"] as? [String : Any]{
                    Intercom.logEvent(withName: name, metaData: metaData)
                }else{
                    Intercom.logEvent(withName: name)
                }
            }
            result("Logged event")
        case "handlePushMessage":
            result("No op")
        case "displayMessageComposer":
            if let message = args["message"] as? String{
                Intercom.presentMessageComposer(message)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
