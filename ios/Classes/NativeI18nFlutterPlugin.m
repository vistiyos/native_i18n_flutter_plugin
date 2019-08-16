#import "NativeI18nFlutterPlugin.h"
#import <native_i18n_flutter_plugin/native_i18n_flutter_plugin-Swift.h>

@implementation NativeI18nFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftI18nPlugin registerWithRegistrar:registrar];
}
@end
