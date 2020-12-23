package fr.ynotes

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.content.Context  
import android.content.Intent  
import android.os.Build
import android.content.ComponentName
import android.content.pm.PackageManager
import android.content.ContextWrapper
import android.util.Log
import android.os.PowerManager
class MainActivity: FlutterActivity() {
    private val CHANNEL = "fr.ynotes/autostart";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        var tag = "fr.ynotes:LOCK"

if (Build.MANUFACTURER.equals("Huawei", ignoreCase = true)) { 
    tag = "LocationManagerService" 
    Log.d("Log", "OUAIS")
}

val pm = this.getSystemService(Context.POWER_SERVICE) as PowerManager
var wl = pm.newWakeLock(1, tag)
if ((wl != null) &&           // we have a WakeLock
    (wl.isHeld() == false)) {  // but we don't hold it 
    wl.acquire();

}
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openAutostartSettings") {
                openAutostartSettings()
                result.success(true)
            }

            // Note: this method is invoked on the main thread.
            // TODO
          }
    }
    fun openAutostartSettings(){
        try {
            val intent = Intent()
            val manufacturer = Build.MANUFACTURER
            Log.d("Manufacturer", manufacturer)
            if ("xiaomi".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity"
                )
            } else if ("oppo".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                ) //need "oppo.permission.OPPO_COMPONENT_SAFE" in the manifest
            } else if ("vivo".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.vivo.permissionmanager",
                    "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"
                )
            } else if ("Letv".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.letv.android.letvsafe",
                    "com.letv.android.letvsafe.AutobootManageActivity"
                )
            } else if ("Honor".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.optimize.process.ProtectActivity"
                )
            } 
            else if ("Huawei".equals(manufacturer, ignoreCase = true)) {
                intent.component = ComponentName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                )
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            } 
            else {
                //Timber.d("Auto-start permission not necessary")
            }
            val list = ContextWrapper(applicationContext).packageManager
                .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
            if (list.size > 0) {
                ContextWrapper(applicationContext).startActivity(intent)
            }
           

        } catch (e: Exception) {
            Log.d("exception",e.toString())
           
        }
    }
    
}
