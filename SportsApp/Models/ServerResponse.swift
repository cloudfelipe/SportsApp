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
    
    /*
    //Next two properties was created because for this Mapper is impossible
    //set in a generic kind object an arrar or single object (Backend response use only one property)
    var data: T? //Read this property if a single object is expected.
    var dataList: [T]? //Read this property if a array of object is expected.
    var messageCode: Int?
    
    var errors: [ResponseError<T>]?
 */
    
    init() {
        
    }
    
    // Mappable protocol
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
//        message     <- map["message"]
//        data        <- map["data"]
//        dataList    <- map["data"]
//        errors      <- map["errors"]
//        messageCode <- map["messageCode"]
        teams <- map["teams"]
    }
}
