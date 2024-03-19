import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // GoogleMap API
    GMSServices.provideAPIKey("AIzaSyCM-iQCm12D9TPziDzdzj1BzUKK_lfKl6E")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
