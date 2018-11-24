//
//  ServerResponse.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ObjectDTO {
    
}

class ServerResponse: Mappable {
    var teams: [Team]?
    var events: [Event]?
    
    init() {
        
    }
    
    // Mappable protocol
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        teams <- map["teams"]
        events <- map["events"]
    }
}
