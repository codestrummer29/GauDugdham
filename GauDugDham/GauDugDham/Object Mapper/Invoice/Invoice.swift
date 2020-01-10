//
//  Invoice.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 07/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class Invoice: Mappable {
    var status : Int?
    var msg : String?
    var subscription_invoice_data : InvoiceData?
    
    required init(map : Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        subscription_invoice_data <- map["subscription_invoice_data"]
    }
}

class InvoiceData: Mappable {
    var subscription_type : String?
    var subscription_status : String?
    var subscription_created_date : String?
    var product_name : String?
    var product_price : String?
    var product_quantity_unit : String?
    var quantity_by_month : [ProductMonthData]?
    
    required init(map : Map) {
        
    }
    
    func mapping(map: Map) {
        subscription_type <- map["subscription_type"]
        subscription_status <- map["subscription_status"]
        subscription_created_date <- map["subscription_created_date"]
        product_name <- map["product_name"]
        product_price <- map["product_price"]
        product_quantity_unit <- map["product_quantity_unit"]
        quantity_by_month <- map["quantity_by_month"]
    }
}

class ProductMonthData: Mappable{
    var total_quantity :String?
    var total_amount : String?
    var date : String?
    
    required init(map : Map) {
        
    }
    
    func mapping(map : Map){
        total_quantity <- map["total_quantity"]
        total_amount <- map["total_amount"]
        date <- map["date"]
    }
}
