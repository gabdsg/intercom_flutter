#import "IntercomFlutterPlugin.h"
#if __has_include(<intercom_flutter/intercom_flutter-Swift.h>)
#import <intercom_flutter/intercom_flutter-Swift.h>
#else
#import "intercom_flutter-Swift.h"
#endif

@implementation IntercomFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIntercomFlutterPlugin registerWithRegistrar:registrar];
}
@end
