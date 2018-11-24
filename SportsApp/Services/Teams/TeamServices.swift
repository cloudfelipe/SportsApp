//
//  TeamServices.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift

protocol TeamServicesInput {
    func getTeams(by league: String, completion: @escaping (_ teams: [Team]?, _ error: NSError?) -> Void)
}

class TeamServices {
    private let provider = MoyaProvider<TeamServicesAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private let disposeBag = DisposeBag()
}

extension TeamServices: TeamServicesInput {
    public func getTeams(by league: String, completion: @escaping ([Team]?, NSError?) -> Void) {
        provider.rx
            .request(.teams(leageId: league))
            .mapObject(ServerResponse.self)
            .subscribe { (event) in
                switch event {
                case .success(let response):
                    completion(response.teams, nil)
                case .error(let error):
                    completion(nil, error as NSError)
                }
        }.disposed(by: disposeBag)
    }
}
