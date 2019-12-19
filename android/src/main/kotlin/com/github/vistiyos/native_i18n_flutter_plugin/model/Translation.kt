package com.github.vistiyos.native_i18n_flutter_plugin.model

import android.support.annotation.Keep
import org.jetbrains.annotations.NotNull

@Keep
data class Translation(
        @field:NotNull
        var translationKey: String,
        var translationArguments: List<String>? = mutableListOf()
)