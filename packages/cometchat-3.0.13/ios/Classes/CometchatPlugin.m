#import "CometchatPlugin.h"
#if __has_include(<cometchat/cometchat-Swift.h>)
#import <cometchat/cometchat-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cometchat-Swift.h"
#endif

@implementation CometchatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCometchatPlugin registerWithRegistrar:registrar];
}
@end
