import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let registrar = self.registrar(forPlugin: "ios_method_channel_experiment")  {
        let factory = ArNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "ar_native_view")
    }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
