import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  private let appGroupId = "group.com.ledoweb.huly"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    setupShareChannel()
    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func setupShareChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "com.ledoweb.huly/share",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else {
        result(FlutterMethodNotImplemented)
        return
      }

      switch call.method {
      case "getPendingShare":
        let userDefaults = UserDefaults(suiteName: self.appGroupId)
        let data = userDefaults?.string(forKey: "pendingShare")
        result(data)

      case "clearPendingShare":
        let userDefaults = UserDefaults(suiteName: self.appGroupId)
        userDefaults?.removeObject(forKey: "pendingShare")
        userDefaults?.synchronize()
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
