//
//  Team.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import ObjectMapper

final class Team: Mappable {
    
    var id: String?
    var name: String?
    var stadium: String?
    var badge: String?
    
    init() {
    }
    
    //MARK: - MAPPABLE
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["strTeam"]
        stadium <- map["strStadium"]
        id <- map["idTeam"]
        badge <- map["strTeamBadge"]
    }
}
