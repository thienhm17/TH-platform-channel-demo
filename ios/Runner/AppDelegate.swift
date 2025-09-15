import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    let healthManager = HealthManager()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "dev.thienhuynh.stepCounter/getSteps",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            switch call.method {
            case "requestAuthorization":
                self.healthManager.requestAuthorization { success, error in
                    result(success)
                }
            case "getSteps":
                self.healthManager.fetchSteps { steps, error in
                    if let steps = steps {
                        result(steps)
                    } else {
                        result(FlutterError(code: "UNAVAILABLE", message: "Steps not available", details: nil))
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
