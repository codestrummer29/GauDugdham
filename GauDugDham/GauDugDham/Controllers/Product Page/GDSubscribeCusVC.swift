//
//  GDSubscribeCusVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 30/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class GDSubscribeCusVC: UIViewController {
    // MARK: - Var declaration

    var sub_status : String? // sub (type)
    
    var productData : ProductData?
    var quant : String?
    var quantMon : Float? = 0.0
    var quantTue : Float? = 0.0
    var quantWed : Float? = 0.0
    var quantThu : Float? = 0.0
    var quantFri : Float? = 0.0
    var quantSat : Float? = 0.0
    var quantSun : Float? = 0.0

    // MARK: - IBOutlets
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var imageProduct: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var butCom: UIButton!
    @IBOutlet weak var labelMon: UILabel!
    @IBOutlet weak var labelFri: UILabel!
    @IBOutlet weak var labelThu: UILabel!
    @IBOutlet weak var labelWed: UILabel!
    @IBOutlet weak var labelTue: UILabel!
    @IBOutlet weak var labelSat: UILabel!
    @IBOutlet weak var labelSun: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(GDSubscribeCusVC.close))
        navTitle.leftBarButtonItem = closeButton
        setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers 
    
    func setUpView() -> Void {
        labelPrice.text = "Rs "+(productData?.product_price)! + "/" + (productData?.product_price_quantity)!+" "+(productData?.product_quantity_unit)!
        labelName.text = productData?.product_name
        imageProduct.sd_setImage(with: URL(string:(productData?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    func close() -> Void {
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    func showLoading(state : Int) -> Void {
        if(state == 1){
            loadingBar.startAnimating()
            let alertController = UIAlertController(title: "Loading!", message: "Please wait while we set up the subscription.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)

        }else{
            loadingBar.stopAnimating()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func alertError(title : String,msg : String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func orderCompleteAlert(msg : String) -> Void {
        let alertController = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func orderComplete(_ sender: Any) {
        if(quantSun != 0.0 || quantSat != 0.0 || quantFri != 0.0 || quantThu != 0.0 || quantWed != 0.0 || quantTue != 0 || quantMon != 0.0){
            let alertController = UIAlertController(title: "Confirm Custom Subscription", message: "Are you sure you want to subscribe to this product ?", preferredStyle: .alert)
        
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
        }else{
            alertError(title: "Error", msg: "Cannot add blank subscription")
        }
    }
    
    // MARK: - Button Sub Functions

    @IBAction func MonAdd(_ sender: Any) {
        if(quantMon != 0.0){
            quantMon = quantMon! - 0.5
        }
        labelMon.text = String(quantMon!)
    }
    @IBAction func TueAdd(_ sender: Any) {
        if(quantTue != 0.0){
            quantTue = quantTue! - 0.5
        }
        labelTue.text = String(quantTue!)
    }
    @IBAction func WedAdd(_ sender: Any) {
        if(quantWed != 0.0){
            quantWed = quantWed! - 0.5
        }
        labelWed.text = String(quantWed!)
    }
    @IBAction func ThuAdd(_ sender: Any) {
        if(quantThu != 0.0){
            quantThu = quantThu! - 0.5
        }
        labelThu.text = String(quantThu!)
    }
    @IBAction func FriAdd(_ sender: Any) {
        if(quantFri != 0.0){
            quantFri = quantFri! - 0.5
        }
        labelFri.text = String(quantFri!)
    }
    @IBAction func SatAdd(_ sender: Any) {
        if(quantSat != 0.0){
            quantSat = quantSat! - 0.5
        }
        labelSat.text = String(quantSat!)
    }
    @IBAction func SunAdd(_ sender: Any) {
        if(quantSun != 0.0){
            quantSun = quantSun! - 0.5
        }
        labelSun.text = String(quantSun!)
    }
    
    // MARK: - Button add Functions
    @IBAction func MonSub(_ sender: Any) {
        if(quantMon != 20.0){
            quantMon = quantMon! + 0.5
        }
        labelMon.text = String(quantMon!)
    }
    @IBAction func TueSub(_ sender: Any) {
        if(quantTue != 20.0){
            quantTue = quantTue! + 0.5
        }
        labelTue.text = String(quantTue!)
    }
    @IBAction func WebSub(_ sender: Any) {
        if(quantWed != 20.0){
            quantWed = quantWed! + 0.5
        }
        labelWed.text = String(quantWed!)
    }
    @IBAction func ThuSub(_ sender: Any) {
        if(quantThu != 20.0){
            quantThu = quantThu! + 0.5
        }
        labelThu.text = String(quantThu!)
    }
    @IBAction func FriSub(_ sender: Any) {
        if(quantFri != 20.0){
            quantFri = quantFri! + 0.5
        }
        labelFri.text = String(quantFri!)
    }
    @IBAction func SatSub(_ sender: Any) {
        if(quantSat != 20.0){
            quantSat = quantSat! + 0.5
        }
        labelSat.text = String(quantSat!)
    }
    @IBAction func SunSub(_ sender: Any) {
        if(quantSun != 20.0){
            quantSun = quantSun! + 0.5
        }
        labelSun.text = String(quantSun!)
    }
    
    // MARK: - Api Call
    
    func placeOrder() -> Void {
        showLoading(state: 1)
        quant = String(quantMon!) + "," + String(quantTue!) + "," + String(quantWed!) + "," + String(quantThu!) + "," + String(quantFri!) + "," + String(quantSat!) + "," + String(quantSun!)
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
                        self.orderCompleteAlert(msg: data["msg"] as! String)
                    }else{
                        // status 2 , error
                        self.alertError(title: "Error !", msg: "Please try again later")
                        self.showLoading(state: 0)
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
