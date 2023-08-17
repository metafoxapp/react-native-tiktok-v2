import Foundation
import TikTokOpenSDKCore
import TikTokOpenAuthSDK

@objc(TiktokV2)
class TiktokV2: NSObject {
  var resolve : RCTPromiseResolveBlock? = nil;
  private var authRequest: TikTokAuthRequest?

  @objc
    func auth(_ scopes: NSString,
      redirectUri: NSString,
      resolver:@escaping RCTPromiseResolveBlock,
      rejecter:@escaping RCTPromiseRejectBlock
    )->Void{
      resolve = resolver;

      let scopesArray:Array = scopes.components(separatedBy: ",");
      var setScopes: Set<String> = [];


      for index in 0 ..< scopesArray.count {
        setScopes.insert(scopesArray[index])
      }

      let authRequest: TikTokAuthRequest = TikTokAuthRequest(scopes: setScopes, redirectURI:redirectUri as String)
      authRequest.isWebAuth = false
      self.authRequest = authRequest

      DispatchQueue.main.sync {
        authRequest.send { response in
          guard let authResponse = response as? TikTokAuthResponse else { return }
          self.handleAuthResponse(authResponse)
        }
      }
    }

    func handleAuthResponse(_ response: TikTokAuthResponse) {
      guard let request = self.authRequest else { return }

      let dict = NSMutableDictionary();
      dict.setValue(response.errorCode.rawValue, forKey:"errorCode")
      dict.setValue(response.errorDescription, forKey:"errorMsg")
      dict.setValue(response.authCode, forKey:"authCode")
      dict.setValue(request.pkce.codeVerifier, forKey:"codeVerifier")

      self.resolve?(dict)
      self.authRequest = nil
    }
}
