package com.ccextractor.beaconmobile

import android.content.res.Configuration
import androidx.annotation.NonNull
import cl.puntito.simple_pip_mode.PipCallbackHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
  private var callbackHelper = PipCallbackHelper()

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    callbackHelper.configureFlutterEngine(flutterEngine)
  }

  override fun onPictureInPictureModeChanged(active: Boolean, newConfig: Configuration?) {
    super.onPictureInPictureModeChanged(active, newConfig)
    callbackHelper.onPictureInPictureModeChanged(active)
  }
}
