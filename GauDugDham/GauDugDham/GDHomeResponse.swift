//
//  GDHomeResponse.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 19/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class GDHomeResponse : Mappable{
    var status : Int?
    var msg : String?
    var banner_data : [BannerData]?
    var product_category_data : [ProductCategoryData]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        banner_data <- map["banner_data"]
        product_category_data <- map["product_category_data"]
        msg <- map["msg"]
    }
}

class BannerData : Mappable{
    var banner_id : String?
    var banner_image_url : String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        banner_id <- map["banner_id"]
        banner_image_url <- map["banner_image_url"]
    }
}

class ProductCategoryData : Mappable{
    var category_id : String?
    var category_type : String?
    var category_img : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map:Map){
        category_id <- map["category_id"]
        category_type <- map["category_type"]
        category_img <- map["category_img"]
    }
}
