package com.github.vistiyos.native_i18n_flutter_plugin

import android.content.Context
import android.support.annotation.Keep
import com.github.vistiyos.native_i18n_flutter_plugin.model.Translation
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

@Keep
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
                val sType = object : TypeToken<List<Translation>>() { }.type
                val translations = Gson().fromJson<List<Translation>>(call.arguments() as String, sType)
                translations
                        .map { Pair(getInternalStringIdentifier(it.translationKey), it) }
                        .map { Pair(it.second.translationKey, getString(it.first, it.second)) }
                        .forEach { translationMap[it.first] = it.second }

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

    private fun getString(internalStringIdentifier: Int, translation: Translation) =
            when (internalStringIdentifier) {
                0 -> translation.translationKey
                else -> context.getString(internalStringIdentifier)
            }
}