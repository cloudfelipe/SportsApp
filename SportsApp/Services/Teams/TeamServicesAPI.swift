//
//  TeamServicesAPI.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import Moya

public enum TeamServicesAPI {
    case teams(leagueId: String)
    case nextFiveEvents(teamId: String)
}

extension TeamServicesAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.thesportsdb.com/api/v1/json/1/")!
    }
    
    public var path: String {
        switch self {
        case .teams:
            return "lookup_all_teams.php"
        case .nextFiveEvents:
            return "eventsnext.php"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .teams, .nextFiveEvents:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .teams(let objectId), .nextFiveEvents(let objectId):
            return .requestParameters(parameters: ["id": objectId], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
