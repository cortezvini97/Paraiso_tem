import UIKit
import Flutter

@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate
{
    
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        
        GeneratedPluginRegistrant.register(with: self)
        
        if #available(iOS 10.0, *)
        {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let channel = FlutterMethodChannel(name: "com.vcinsidedigital.paraisotem/web", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
            var map = call.arguments as? Dictionary<String, String>
            
            if call.method == "web"
            {
                var url = map?["url"]
                self.openPginaWeb(url: url!)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func openPginaWeb(url: String)
    {
        if let link = URL(string: url)
        {
            UIApplication.shared.openURL(link)
        }
    }
    
}
