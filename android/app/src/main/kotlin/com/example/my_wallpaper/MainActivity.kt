package com.example.my_wallpaper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.graphics.Bitmap
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import android.provider.MediaStore

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.my_wallpaper/setWallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val bytes = call.arguments as ByteArray
                setWallpaper(bytes)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setWallpaper(bytes: ByteArray) {
        val wallpaperManager = WallpaperManager.getInstance(context)
        val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(bytes))
        val intent = Intent(wallpaperManager.getCropAndSetWallpaperIntent(getImageUri(context, bitmap)))
        startActivity(intent)
        finish()
    }

    private fun getImageUri(context: Context, bitmap: Bitmap): Uri{
        val bytes = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bytes)
        val path = MediaStore.Images.Media.insertImage(context.contentResolver, bitmap, "Title", null)
        return Uri.parse(path.toString())
    }
}