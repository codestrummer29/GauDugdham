//
//  GDProductPageVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 23/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class GDProductPageVC: UIViewController {

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var labelDisplayPrice: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelQuantityamount: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var butCon: UIButton!
    @IBOutlet weak var butPos: UIButton!
    @IBOutlet weak var butNeg: UIButton!
    
    var productData : ProductData?
    var quant : Int?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productData ?? "")
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
        quant = 1
        labelDisplayPrice.text = "Rs "+(productData?.product_price)! + "/" + (productData?.product_price_quantity)!+(productData?.product_quantity_unit)!
        labelTitle.text = productData?.product_name
        imageProduct.sd_setImage(with: URL(string:(productData?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        setAptPrice()
    }
    
    func close() -> Void {
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    func setAptPrice() -> Void {
        labelQuantity.text = String(quant!)
        labelQuantityamount.text =  String(quant!*Int((productData?.product_price_quantity)!)!) + " " + (productData?.product_quantity_unit)!
        labelPrice.text = "Rs " + String(quant!*Int((productData?.product_price)!)!)
    }
    
    func alertError(title : String,msg : String) -> Void {
        showLoading(state: 0)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func orderAlert() -> Void {
        
        let alertController = UIAlertController(title: "Place Order", message: "Are you sure ?" + "\n" + "Amount : " + "Rs " + String(quant!*Int((productData?.product_price)!)!), preferredStyle: .alert)
        
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
    
    func orderComplete(msg : String) -> Void {
        showLoading(state: 0)
        let alertController = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    // MARK: - Button functions

    @IBAction func butReduce(_ sender: Any) {
        if(quant != 1){
            quant = quant! - 1
            setAptPrice()
        }
    }
    
    @IBAction func butIncrease(_ sender: Any) {
        if(quant != 20){
            quant = quant! + 1
            setAptPrice()
        }
    }
    
    @IBAction func butConfirmOrder(_ sender: Any) {
        orderAlert()
    }
    
    // MARK: - Api Call
    
    func placeOrder() -> Void {
        showLoading(state: 1)
        let params:[String:AnyObject] =
            [
                "product_id":productData?.product_id as AnyObject,
                "product_quantity":quant as AnyObject,
                "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject,
                "mobile_no":UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber) as AnyObject
            ]
        Alamofire.request(Constants.ApiUrl.place_order, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            if response.result.isSuccess{
                if let data = response.result.value as? [String:AnyObject] {
                    if (data["status"]?.isEqual(1))!{
                        self.orderComplete(msg: data["msg"] as! String)
                    }else{
                        // status 2 , error
                        self.alertError(title: "Error !", msg: "Please try again later")
                    }
                }
            }else{
                // not success
                self.alertError(title: "Error !", msg: "Please check your internet connection and try again later")
            }
        }
    }
}
