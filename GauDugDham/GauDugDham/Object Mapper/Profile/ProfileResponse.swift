//
//  ProfileResponse.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 20/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class ProfileResponse: Mappable {
    var status : Int?
    var msg : String?
    var subscription_count : String?
    var order_count : String?
    
    required init(map : Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        subscription_count <- map["subscription_count"]
        order_count <- map["order_count"]
    }

}
