import Flutter
import UIKit

public class SwiftI18nPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_i18n_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftI18nPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getTranslations" {
        let arguments:NSDictionary = call.arguments as! NSDictionary
        let translationKeys:NSArray = arguments.value(forKey: "translationKeys") as! NSArray
        var translations : [String: String] = [:]
        
        translationKeys.forEach { translationKey in
            let translationKeyString = translationKey as! String
            translations[translationKeyString] = NSLocalizedString(translationKeyString, comment: "")
        }
        
        result(translations)
        return
    } else {
        result(FlutterMethodNotImplemented)
        return
    }
  }
}
