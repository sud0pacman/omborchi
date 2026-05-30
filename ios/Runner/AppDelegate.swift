import Flutter
import UIKit
import Network

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  private let monitor = NWPathMonitor()
  private var channel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    startNetworkMonitoring()
    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // ✅ Register channel here instead of in didFinishLaunchingWithOptions
    // FlutterPluginRegistry is available and safe at this point
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NetworkPlugin") {
      channel = FlutterMethodChannel(
        name: "com.omborchi/network",
        binaryMessenger: registrar.messenger()
      )
    }
  }

  private func startNetworkMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
      DispatchQueue.main.async {
        if path.status == .unsatisfied {
          self?.channel?.invokeMethod("networkUnavailable", arguments: nil)
        } else {
          self?.channel?.invokeMethod("networkAvailable", arguments: nil)
        }
      }
    }
    monitor.start(queue: DispatchQueue.global())
  }
}