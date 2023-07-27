#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TiktokV2, NSObject)

  RCT_EXTERN_METHOD(auth: (RCTResponseSenderBlock)callback)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}


@end
