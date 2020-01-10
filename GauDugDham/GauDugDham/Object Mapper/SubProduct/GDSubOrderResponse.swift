//
//  GDSubOrderResponse.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 30/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class GDSubOrderResponse: Mappable{
    var status : Int?
    var msg : String?
    var orders : [OrderData]?
    var subscriptions : [SubscriptionData]?
    
    required init(map : Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        orders <- map["orders"]
        subscriptions <- map["subscriptions"]
    }
}

class OrderData : Mappable{
    var product_id : String?
    var order_id : String?
    var total_price : Int?
    var product_name: String?
    var product_img_url : String?
    var product_price : String?
    var order_status : String?
    var time : String?
    var product_quantity : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        order_id <- map["order_id"]
        total_price <- map["total_price"]
        product_name <- map["product_name"]
        product_img_url <- map["product_img_url"]
        product_price <- map["product_price"]
        order_status <- map["order_status"]
        time <- map["time"]
        product_quantity <- map["product_quantity"]
    }
}

class SubscriptionData : Mappable{
    var product_id : String?
    var subscription_id : String?
    var subscription_status : String?
    var subscription_type : String?
    var product_quantity_unit : String?
    var product_name: String?
    var product_img_url : String?
    var product_price : String?
    var time : String?
    var product_quantity : [OrderQuantity]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        subscription_id <- map["subscription_id"]
        subscription_status <- map["subscription_status"]
        subscription_type <- map["subscription_type"]
        product_quantity_unit <- map["product_quantity_unit"]
        product_name <- map["product_name"]
        product_img_url <- map["product_img_url"]
        product_price <- map["product_price"]
        time <- map["time"]
        product_quantity <- map["product_quantity"]
    }
}

class OrderQuantity : Mappable{
    var status : Int?
    var quantity : String?
    var status_msg : String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        quantity <- map["quantity"]
        status_msg <- map["status_msg"]
    }
}
