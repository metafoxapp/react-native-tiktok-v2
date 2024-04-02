# react-native-tiktok-v2

This package aims to help you Sign in with TikTok using new TikTok SDK.

## Installation
### 1. Install the library
using either Yarn:

```
yarn add react-native-tiktok-v2
```

or npm:

```
npm install react-native-tiktok-v2
```

### 2. Link
In iOS:

```bash
$ cd ios/ && pod install
```

### 3. Configure your project
#### 3.1 iOS
Before you can run the project, follow the [TikTok OpenSDK for iOS - Quickstart](https://developers.tiktok.com/doc/mobile-sdk-ios-quickstart/). You can skip the **"Install the SDK"** step.

**NOTE:** The above link (Step 3 and 4) contains Swift code instead of Objective-C which is inconvenient since `react-native` ecosystem still relies
on Objective-C. To make it work in Objective-C you need to do the following in `/ios/PROJECT/AppDelegate.m`:
1. Create "projectName-Bridging-Header.h" file and add to this file:
```objc
  @import TikTokOpenSDKCore;
  @import TikTokOpenAuthSDK;
```

2. After that, import this file to your AppDelegate.mm:

```objc
  #import "projectName-Bridging-Header.h"
```

3. Add the following:
```objc
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  return [TTKSDKURLHandler handleOpenURL:url];
}
```

```objc
- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
    restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
  return [TTKSDKURLHandler handleOpenURL:userActivity.webpageURL];
}
```

#### 3.2 Android
Before you can run the project, follow the [TikTok OpenSDK for Android - Quickstart](https://developers.tiktok.com/doc/mobile-sdk-android-quickstart/).

**NOTE:** Just do **Step 2** when you have build relevant issues.

## Usage

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
