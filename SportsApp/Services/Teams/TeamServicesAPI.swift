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
    case teams(leageId: String)
}

extension TeamServicesAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.thesportsdb.com/api/v1/json/1/")!
    }
    
    public var path: String {
        switch self {
        case .teams:
            return "lookup_all_teams.php"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .teams:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .teams(let leagueId):
            return .requestParameters(parameters: ["id": leagueId], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
