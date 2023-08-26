import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      weak var registar = self.registar(forPlugin: "my-views")
      let cealQrViewfactory = ArNativeViewFactory(messenger: registar!.messenger())
      let viewRegistar = self.registar(forPlugin: "<my-views>")!
      viewRegistar.registar(cealQrViewfactory, withId: "arNativeView")
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
