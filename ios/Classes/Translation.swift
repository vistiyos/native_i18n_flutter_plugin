//
//  Translation.swift
//  native_i18n_flutter_plugin
//
//  Created by Victor on 24/08/2019.
//

import Foundation
import ObjectMapper

struct Translation : Mappable {
    var translationKey : String = ""
    var translationArguments : [String] = []
    
    init?(map: Map) {
        print(map)
    }
    
    mutating func mapping(map: Map) {
        translationKey <- map["translationKey"]
        translationArguments <- map["translationArguments"]
    }
    
}
