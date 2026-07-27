package com.example.bloc_app_demo 

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.eliteathlete/location"
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getCurrentLocation") {
                
                // 1. Kiểm tra quyền
                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    // Yêu cầu hệ điều hành hiện Popup xin quyền
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 100)
                    result.error("PERMISSION_DENIED", "Bạn chưa cấp quyền truy cập vị trí", null)
                    return@setMethodCallHandler
                }

                // 2. Đã có quyền -> Lấy tọa độ
                fusedLocationClient.lastLocation.addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        // Trả về chuỗi String chứa Kinh độ, Vĩ độ
                        result.success("${location.latitude},${location.longitude}")
                    } else {
                        result.error("UNAVAILABLE", "Không tìm thấy tín hiệu GPS. Vui lòng bật Vị trí trên điện thoại.", null)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}