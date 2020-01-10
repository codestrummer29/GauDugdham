//
//  GDSubscribeVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 30/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class GDSubscribeVC: UIViewController {
    
    var sub_status : String?
    var productData : ProductData?
    var quant : Float?
    
    @IBOutlet weak var butCon: UIButton!
    @IBOutlet weak var butNeg: UIButton!
    @IBOutlet weak var butPos: UIButton!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSubType: UILabel!
    @IBOutlet weak var labelQuant: UILabel!
    @IBOutlet weak var labelEstimatePrice: UILabel!
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!

    @IBOutlet weak var labelselectQuant: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(GDProductPageVC.close))
        navTitle.leftBarButtonItem = closeButton
        setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func setUpView() -> Void {
        quant = 0.5
        labelPrice.text = "Rs "+(productData?.product_price)! + "/" + (productData?.product_price_quantity)!+" "+(productData?.product_quantity_unit)!
        labelName.text = productData?.product_name
        imageProduct.sd_setImage(with: URL(string:(productData?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        if(sub_status == "2"){
            labelSubType.text = "Product will be delivered every alternate day starting from tomorrow."
        }else{
            labelSubType.text = "Product will be delivered every day starting from tomorrow."
        }
        labelselectQuant.text = "Select Quantity (" + (productData?.product_quantity_unit)! + ")"
        setAptPrice()
    }
    
    func setAptPrice() -> Void {
        labelQuant.text = String(quant!)
        if(sub_status == "2"){
            labelEstimatePrice.text = "Approximate monthly cost : Rs " + String(15*quant!*Float((productData?.product_price)!)!)
        }else{
            labelEstimatePrice.text = "Approximate monthly cost : Rs " + String(30*quant!*Float((productData?.product_price)!)!)
        }
    }
    
    func close() -> Void {
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    func showLoading(state : Int) -> Void {
        if(state == 1){
            loadingBar.startAnimating()
            butCon.isEnabled = false
            butNeg.isEnabled = false
            butPos.isEnabled = false
        }else{
            loadingBar.stopAnimating()
            butCon.isEnabled = true
            butNeg.isEnabled = true
            butPos.isEnabled = true
        }
    }
    
    func orderComplete(msg : String) -> Void {
        let alertController = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertError(title : String,msg : String) -> Void {
        showLoading(state: 0)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Button Functions
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        if(quant != 0.5){
            quant = quant! - 0.5
            setAptPrice()
        }
    }

    @IBAction func increaseQuantity(_ sender: Any) {
        if(quant != 50.0){
            quant = quant! + 0.5
            setAptPrice()
        }
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirm Subscription", message: "Are you sure ?" + "\n" + "Quantity : " + String(quant!) + " " + (productData?.product_quantity_unit)!, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.placeOrder()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api Call
    
    func placeOrder() -> Void {
        showLoading(state: 1)
        let params:[String:AnyObject] =
            [
                "subscription_type":sub_status as AnyObject,
                "product_id":productData?.product_id as AnyObject,
                "quantity_week":quant as AnyObject,
                "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject,
                "mobile_no":UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber) as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.place_subscription, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            if response.result.isSuccess{
                self.showLoading(state: 0)
                if let data = response.result.value as? [String:AnyObject] {
                    if (data["status"]?.isEqual(1))!{
                        self.orderComplete(msg: data["msg"] as! String)
                    }else{
                        // status 2 , error
                        self.alertError(title: "Error !", msg: "Please try again later")
                    }
                }
            }else{
                self.showLoading(state: 0)
                // not success
                self.alertError(title: "Error !", msg: "Please check your internet connection and try again later")
            }
        }
    }
    
}
