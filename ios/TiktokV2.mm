#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TiktokV2, NSObject)

RCT_EXTERN_METHOD(auth: (NSString *)scope
  redirectUri:(NSString *)redirectUri
  resolver:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject
)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
