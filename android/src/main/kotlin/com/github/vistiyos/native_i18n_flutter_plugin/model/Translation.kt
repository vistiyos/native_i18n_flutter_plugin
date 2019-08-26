package com.github.vistiyos.native_i18n_flutter_plugin.model

import org.jetbrains.annotations.NotNull

data class Translation(
        @field:NotNull
        var translationKey: String,
        var translationArguments: List<String>? = mutableListOf()
)