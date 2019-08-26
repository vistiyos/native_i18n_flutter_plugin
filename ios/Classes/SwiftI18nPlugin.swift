import Flutter
import UIKit
import ObjectMapper

public class SwiftI18nPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_i18n_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftI18nPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getTranslations" {
        let translations:[Translation] = Mapper<Translation>().mapArray(JSONString: call.arguments as! String) ?? []
        var translationsMap : [String: String] = [:]
    
        translations.forEach { translation in
            translationsMap[translation.translationKey] = NSLocalizedString(translation.translationKey, comment: "")
        }
        
        result(translationsMap)
        return
    } else {
        result(FlutterMethodNotImplemented)
        return
    }
  }
}
