//
//  GDProductViewResponse.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 01/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class ProductViewData: Mappable {
    var status : Int?
    var msg : String?
    var products_data : [ProductData]?
    
    required init(map : Map) {

    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        products_data <- map["products_data"]
    }
}

class ProductData : Mappable{
    var product_id : String?
    var category_id : String?
    var product_type : String?
    var product_name: String?
    var product_img_url : String?
    var product_price : String?
    var product_price_quantity : String?
    var product_quantity_unit : String?
    var product_subscribable : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        category_id <- map["category_id"]
        product_type <- map["product_type"]
        product_name <- map["product_name"]
        product_img_url <- map["product_img_url"]
        product_price <- map["product_price"]
        product_price_quantity <- map["product_price_quantity"]
        product_quantity_unit <- map["product_quantity_unit"]
        product_subscribable <- map["product_subscribable"]
    }
}
