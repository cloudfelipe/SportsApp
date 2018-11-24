//
//  Team.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import ObjectMapper

enum SocialNetworkType: String {
    case facebook = "Facebook"
    case instagram = "Instagram"
    case youtube = "Youtube"
    case website = "Website"
    case twitter = "Twitter"
}

struct SocialNetwork {
    let type: SocialNetworkType
    let url: String
}

final class Team: Mappable {
    
    var teamId: String?
    var name: String?
    var stadium: String?
    var badge: String?
    
    //For detail
    var teamDescriptionEN: String? //Used default EN
    var teamDescriptionES: String? //Used default EN
    var stadiumThumb: String?
    var jerse: String?
    var website: String?
    var facebook: String?
    var twitter: String?
    var instagram: String?
    var formedYear: String?
    var youtube: String?
    
    ///Helper method to get all valid social networks
    var socialNetworks: [SocialNetwork] {
        var networks = [SocialNetwork]()
        if let url = facebook, !url.isEmpty {
            networks.append(SocialNetwork(type: .facebook, url: url))
        }
        if let url = website, !url.isEmpty {
            networks.append(SocialNetwork(type: .website, url: url))
        }
        if let url = twitter, !url.isEmpty {
            networks.append(SocialNetwork(type: .twitter, url: url))
        }
        if let url = instagram, !url.isEmpty {
            networks.append(SocialNetwork(type: .instagram, url: url))
        }
        if let url = youtube, !url.isEmpty {
            networks.append(SocialNetwork(type: .youtube, url: url))
        }
        return networks
    }
    
    init() {
    }
    
    // MARK: - Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["strTeam"]
        stadium <- map["strStadium"]
        teamId <- map["idTeam"]
        badge <- map["strTeamBadge"]
        
        teamDescriptionEN <- map["strDescriptionEN"]
        teamDescriptionES <- map["strDescriptionES"]
        stadiumThumb <- map["strStadiumThumb"]
        jerse <- map["strTeamJersey"]
        website <- map["strWebsite"]
        facebook <- map["strFacebook"]
        twitter <- map["strTwitter"]
        instagram <- map["strInstagram"]
        formedYear <- map["intFormedYear"]
        youtube <- map["strYoutube"]
    }
}
