//
//  Event.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import ObjectMapper

final class Event: Mappable {
    var eventId: String?
    var name: String?
    var competition: String?
    var startDate: String?
    var startTime: String?
    var thumUrl: String?
    
    init() {
    }
    
    // MARK: - Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["strEvent"]
        competition <- map["strLeague"]
        startDate <- map["strDate"]
        startTime <- map["strTime"]
        thumUrl <- map["strThumb"]
    }
}
