import Foundation
import TikTokOpenSDKCore
import TikTokOpenAuthSDK

@objc(TiktokV2)
class TiktokV2: NSObject {
  var resolve : RCTPromiseResolveBlock? = nil;

  @objc
    func auth(_ scopes: NSString,
      redirectUri: NSString,
      resolver:@escaping RCTPromiseResolveBlock,
      rejecter:@escaping RCTPromiseRejectBlock
    )->Void{
      resolve = resolver;

      let scopesArray:Array = scopes.components(separatedBy: ",");
      var setScopes: Set<String> = [];
      let dict = NSMutableDictionary();

      for index in 0 ..< scopesArray.count {
        setScopes.insert(scopesArray[index])
      }

      let authRequest = TikTokAuthRequest(scopes: setScopes, redirectURI:redirectUri as String)
      authRequest.isWebAuth = false

      DispatchQueue.main.sync {
        authRequest.send { response in
          guard let authResponse = response as? TikTokAuthResponse else { return }
          dict.setValue(authResponse.errorCode.rawValue, forKey:"errorCode")
          dict.setValue(authResponse.errorDescription, forKey:"errorMsg")
          dict.setValue(authResponse.authCode, forKey:"authCode")
          dict.setValue(scopes, forKey:"grantedPermissions")
          dict.setValue(authRequest.pkce.codeVerifier, forKey:"codeVerifier")
          dict.setValue(redirectUri, forKey:"redirectUri")
          self.resolve?(dict)
        }
      }
    }
}
