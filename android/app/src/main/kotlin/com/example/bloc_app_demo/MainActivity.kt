package com.example.bloc_app_demo

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
import android.location.Geocoder
import java.util.Locale
import android.os.Build
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.eliteathlete/location"
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getCurrentLocation") {

                
                if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 100)
                    result.error("PERMISSION_DENIED", "Bạn chưa cấp quyền truy cập vị trí", null)
                    return@setMethodCallHandler
                }

            
                // Function phụ trợ để dịch tọa độ sang địa chỉ
                fun processLocation(location: Location) {
                    try {
                        val geocoder = Geocoder(this, Locale.getDefault())
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            geocoder.getFromLocation(location.latitude, location.longitude, 1) { addresses ->
                                if (addresses.isNotEmpty()) {
                                    val addressString = addresses[0].getAddressLine(0)
                                    runOnUiThread { result.success(addressString) }
                                } else {
                                    runOnUiThread { result.success("${location.latitude},${location.longitude}") }
                                }
                            }
                        } else {
                            val addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1)
                            if (!addresses.isNullOrEmpty()) {
                                result.success(addresses[0].getAddressLine(0))
                            } else {
                                result.success("${location.latitude},${location.longitude}")
                            }
                        }
                    } catch (e: Exception) {
                        result.success("${location.latitude},${location.longitude}")
                    }
                }

                    // 2. Đã có quyền -> Lấy tọa độ
                fusedLocationClient.lastLocation.addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        processLocation(location)
                    } else {
                        // NẾU CACHE NULL -> Ép máy chủ động định vị mới ngay lập tức
                        val cancellationTokenSource = CancellationTokenSource()
                        fusedLocationClient.getCurrentLocation(
                            Priority.PRIORITY_HIGH_ACCURACY,
                            cancellationTokenSource.token
                        )
                            .addOnSuccessListener { freshLocation: Location? ->
                                if (freshLocation != null) {
                                    processLocation(freshLocation)
                                } else {
                                    result.error("UNAVAILABLE", "Không thể xác định vị trí hiện tại.", null)
                                }
                            }
                            .addOnFailureListener {
                                result.error("UNAVAILABLE", "Lỗi phần cứng GPS.", null)
                            }
                    }
                }

            } else {
                result.notImplemented()
            }
        }
    }
}