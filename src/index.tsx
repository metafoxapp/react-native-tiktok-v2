import { NativeModules, Platform, NativeEventEmitter } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-tiktok-auth' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

enum TikTokAuthResponseErrorCode {
  noError = 0,
  common = -1,
  cancelled = -2,
  failed = -3,
  denied = -4,
  unsupported = -5,
  missingParams = 10005,
  unknown = 100000,
}

type ResponseType = {
  authCode?: string;
  errorCode: TikTokAuthResponseErrorCode;
  errorDescription?: string;
  codeVerifier: string;
};

const TiktokV2 = NativeModules.TiktokV2
  ? NativeModules.TiktokV2
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export const authorize = (
  scopes: string,
  redirectUri: string,
  callback: (resp: ResponseType) => void
) => {
  TiktokV2.auth(scopes, redirectUri).then(async (resp: ResponseType) => {
    if (resp) {
      callback(resp);
    }
  });
};

export const initClientKey = (key: string) => {
  if (Platform.OS === 'android') {
    TiktokV2.initClientKey(key);
  }
};

const addListener = (_listener: string, _event: any) => {};

export const events =
  Platform.OS === 'android'
    ? new NativeEventEmitter(TiktokV2)
    : { addListener };
