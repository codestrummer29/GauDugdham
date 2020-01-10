//
//  GDConstants.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 06/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//
import Foundation
import UIKit

struct Constants {
    
    struct LoginIdentifiers {
        static let userLoginTokenKey = "userLoginTokenKey"
    }
    
    struct Colors {
        static let Green = UIColor(
        red: 83.0/255.0,
        green: 181.0/255.0,
        blue: 114.0/255.0,
        alpha: CGFloat(1.0)
        )
        static let Red = UIColor(
            red: 204.0/255.0,
            green: 51.0/255.0,
            blue: 0.0/255.0,
            alpha: CGFloat(1.0)
        )
        static let AppColor = UIColor(
            red: 76.0/255.0,
            green: 117.0/255.0,
            blue: 163.0/255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    struct ApiUrl {
        static let base_api = "http://gaudugdham.com/gaudugdham-api-ios/public/"
        static let login = ApiUrl.base_api + "auth/login/"
        static let register = ApiUrl.base_api + "auth/register/"
        static let verify_number = ApiUrl.base_api + "auth/verify_mobile_unique/"
        static let home_page = ApiUrl.base_api + "feed/home/"
        static let mobile_change = ApiUrl.base_api + "auth/reset_mobile/"
        static let add_change = ApiUrl.base_api + "auth/update_profile/"
        static let product_page = ApiUrl.base_api + "feed/products/"
        static let place_order = ApiUrl.base_api + "order/make/"
        static let place_subscription = ApiUrl.base_api + "subscription/add/"
        static let getOrders = ApiUrl.base_api + "orders/placed/"
        static let cancelOrder = ApiUrl.base_api + "order/set/"
        static let changeSubStatus = ApiUrl.base_api + "subscription/set/"
        static let editSubscription = ApiUrl.base_api + "subscription/edit/"
        static let sendOtp = ApiUrl.base_api + "auth/sendotp/"
        static let getInvoice = ApiUrl.base_api + "subscription/invoice/"
        static let getProfileData = ApiUrl.base_api + "user/profile/"
    }
    
    struct UserDetails {
        static let name = "name"
        static let mobileNumber = "mobileNumber"
        static let address = "address"
        static let city = "city"
        static let pincode = "pincode"
        static let password = "password"
    }
}
