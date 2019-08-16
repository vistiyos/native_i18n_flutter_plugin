package com.github.vistiyos.native_i18n_flutter_plugin

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class NativeI18nFlutterPlugin(private var context: Context) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_i18n_flutter_plugin")
            channel.setMethodCallHandler(NativeI18nFlutterPlugin(registrar.activeContext()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getTranslations" -> {
                val translationMap = mutableMapOf<String, String>()
                call.argument<List<String>>("translationKeys")
                        ?.stream()
                        ?.map { translationKey -> Pair<String, Int>(translationKey, getInternalStringIdentifier(translationKey)) }
                        ?.map { pair -> Pair<String, String>(pair.first, getString(pair.second, pair.first)) }
                        ?.forEach { pair -> translationMap[pair.first] = pair.second }

                when (translationMap.size) {
                    0 -> result.error("Translations not found", null, null)
                    else -> result.success(translationMap)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun getInternalStringIdentifier(stringIdentifier: String) =
            context.resources.getIdentifier(stringIdentifier, "string", context.packageName)

    private fun getString(internalStringIdentifier: Int, stringIdentifier: String) =
            when (internalStringIdentifier) {
                0 -> stringIdentifier
                else -> context.getString(internalStringIdentifier)
            }
}