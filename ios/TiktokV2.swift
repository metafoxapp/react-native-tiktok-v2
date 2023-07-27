import TikTokOpenAuthSDK

@objc(TiktokV2)
class TiktokV2: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }

  @objc
    func auth(_ callback: @escaping RCTResponseSenderBlock) {

      let authRequest = TikTokAuthRequest(scopes: ["user.info.basic"], redirectURI: "https://www.example.com/path")

    }
}
