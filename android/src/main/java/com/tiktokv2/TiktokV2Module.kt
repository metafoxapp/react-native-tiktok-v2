package com.tiktokv2

import android.app.Activity
import android.content.Intent
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule

import com.tiktok.open.sdk.auth.AuthApi
import com.tiktok.open.sdk.auth.AuthRequest
import com.tiktok.open.sdk.auth.utils.PKCEUtils

class TiktokV2Module(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext), ActivityEventListener {
  private lateinit var authApi: AuthApi
  private lateinit var redirectUri: String
  private lateinit var clientKey: String

  private val mReactContext = reactContext
  private val codeVerifier = PKCEUtils.generateCodeVerifier()

  override fun getName(): String {
    return NAME
  }

  init {
    reactContext.addActivityEventListener(this)
  }

  @ReactMethod
  fun initClientKey(key: String) {
    this.clientKey = key
  }

  @ReactMethod
  fun auth(scopes: String, redirectUri: String, promise: Promise) {
    this.authApi = this.mReactContext.currentActivity?.let { AuthApi(activity = it) }!!

    // redirectUri in Android should not have "/" at the end of string.
    if (redirectUri.last() == '/') {
      this.redirectUri = redirectUri.dropLast(1)
    } else {
      this.redirectUri = redirectUri
    }

    val request = AuthRequest(
      clientKey = this.clientKey,
      scope = scopes,
      redirectUri = redirectUri,
      codeVerifier = this.codeVerifier,
    )

    this.authApi.authorize(
      request = request,
      authMethod = AuthApi.AuthMethod.TikTokApp
    )
  }

  override fun onActivityResult(p0: Activity?, p1: Int, p2: Int, p3: Intent?) {}

  override fun onNewIntent(intent: Intent?) {
    this.authApi.getAuthResponseFromIntent(intent, this.redirectUri)?.let {
      val result: WritableMap = Arguments.createMap()
      result.putInt("errorCode", it.errorCode)
      result.putString("authCode", it.authCode)
      result.putString("codeVerifier", codeVerifier)
      result.putString("errorMsg", it.authErrorDescription)

      this.mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit("onAuthCompleted", result)
    }
  }

  companion object {
    const val NAME = "TiktokV2"
  }
}
