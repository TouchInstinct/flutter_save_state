package ru.touchin.flutterapp

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import android.os.Bundle
import android.R.attr.keySet
import java.util.HashMap
import android.os.Parcelable


class MainActivity() : FlutterActivity() {

    var savedFromFlutter: MutableMap<String, String> = mutableMapOf()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler { call, result ->
            if (call.method.contentEquals("saveInput")) {
                savedFromFlutter.put(call.argument<String>("key"), call.argument<String>("value"))
            } else if (call.method.contentEquals("readInput")) {
                result.success(savedFromFlutter.get(call.argument<String>("key")))
            } else if (call.method.contentEquals("wasRestarted")) {
                result.success(savedInstanceState != null)
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable("savedFromFlutter", toBundle(savedFromFlutter));
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        savedFromFlutter = fromBundle(savedInstanceState.getParcelable<Bundle>("savedFromFlutter"))
    }
}

fun toBundle(input: Map<String, String>): Bundle {
    val output = Bundle()
    for (key in input.keys) {
        output.putString(key, input[key])
    }
    return output
}

fun fromBundle(input: Bundle): MutableMap<String, String> {
    val output: MutableMap<String, String> = mutableMapOf()
    for (key in input.keySet()) {
        output.put(key, input.getString(key))
    }
    return output
}