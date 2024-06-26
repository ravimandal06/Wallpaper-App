package com.example.vrit

import android.app.WallpaperManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel").setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val imageUrl = call.arguments as String
                setWallpaper(imageUrl, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setWallpaper(imageUrl: String, result: MethodChannel.Result) {
        thread {
            try {
                val url = URL(imageUrl)
                val connection: HttpURLConnection = url.openConnection() as HttpURLConnection
                connection.doInput = true
                connection.connect()
                val inputStream = connection.inputStream
                val bitmap = BitmapFactory.decodeStream(inputStream)

                val wallpaperManager = WallpaperManager.getInstance(applicationContext)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    wallpaperManager.setBitmap(bitmap, null, false, WallpaperManager.FLAG_SYSTEM)
                    result.success("Wallpaper set successfully")
                } else {
                    wallpaperManager.setBitmap(bitmap)
                    result.success("Wallpaper set successfully")
                }
            } catch (e: IOException) {
                result.error("WALLPAPER_ERROR", "Failed to set wallpaper", e.message)
            }
        }
    }
}
