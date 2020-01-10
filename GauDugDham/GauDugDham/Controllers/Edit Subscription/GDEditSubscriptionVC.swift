//
//  GDEditSubscriptionVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 01/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire

class GDEditSubscriptionVC: UIViewController {
    
    // MARK: - Var declaration
    
    var sub_type : String?
    var productData : SubscriptionData?
    var quant : String?
    var quantMon : Float? = 0.0
    var quantTue : Float? = 0.0
    var quantWed : Float? = 0.0
    var quantThu : Float? = 0.0
    var quantFri : Float? = 0.0
    var quantSat : Float? = 0.0
    var quantSun : Float? = 0.0
    var default_flag : String?

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelMon: UILabel!
    @IBOutlet weak var labelTue: UILabel!
    @IBOutlet weak var labelWed: UILabel!
    @IBOutlet weak var labelThu: UILabel!
    @IBOutlet weak var labelFri: UILabel!
    @IBOutlet weak var labelSat: UILabel!
    @IBOutlet weak var labelSun: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func setUpView() -> Void {
        labelPrice.text = "Rs " + (productData?.product_price)! + "/" + (productData?.product_quantity_unit)!
        labelName.text = productData?.product_name
        imageProduct.sd_setImage(with: URL(string:(productData?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        quantMon = Float((productData?.product_quantity?[0].quantity)!)
        quantTue = Float((productData?.product_quantity?[1].quantity)!)
        quantWed = Float((productData?.product_quantity?[2].quantity)!)
        quantThu = Float((productData?.product_quantity?[3].quantity)!)
        quantFri = Float((productData?.product_quantity?[4].quantity)!)
        quantSat = Float((productData?.product_quantity?[5].quantity)!)
        quantSun = Float((productData?.product_quantity?[6].quantity)!)
        labelMon.text = String(quantMon!)
        labelTue.text = String(quantTue!)
        labelWed.text = String(quantWed!)
        labelThu.text = String(quantThu!)
        labelFri.text = String(quantFri!)
        labelSat.text = String(quantSat!)
        labelSun.text = String(quantSun!)
        default_flag = "0"
        setLabelColors()
    }
    
    func alertError(title : String,msg : String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoading(state : Int) -> Void {
        if(state == 1){
            let alertController = UIAlertController(title: "Loading!", message: "Please wait while we set up the subscription.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setDefaultFlag() -> Void {
        let alertController = UIAlertController(title: "Please Select", message: "Do you want to make this subscription as your default subscription?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Make Default", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.default_flag = "1"
            self.editOrder()
        }
        let cancelAction = UIAlertAction(title: "These chages are for coming week only", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.default_flag = "0"
            self.editOrder()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func orderCompleteAlert(msg : String) -> Void {
        let alertController = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setLabelColors() -> Void {
        if(productData?.product_quantity?[0].status == 1){
            labelMon.textColor = Constants.Colors.Green
        }else{
            labelMon.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[1].status == 1){
            labelTue.textColor = Constants.Colors.Green
        }else{
            labelTue.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[2].status == 1){
            labelWed.textColor = Constants.Colors.Green
        }else{
            labelWed.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[3].status == 1){
            labelThu.textColor = Constants.Colors.Green
        }else{
            labelThu.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[4].status == 1){
            labelFri.textColor = Constants.Colors.Green
        }else{
            labelFri.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[5].status == 1){
            labelSat.textColor = Constants.Colors.Green
        }else{
            labelSat.textColor = Constants.Colors.Red
        }
        if(productData?.product_quantity?[6].status == 1){
            labelSun.textColor = Constants.Colors.Green
        }else{
            labelSun.textColor = Constants.Colors.Red
        }
    }
    
    // MARK: - Button Add Functions

    @IBAction func monAdd(_ sender: Any) {
        if(productData?.product_quantity?[0].status == 1){
            if(quantMon != 20.0){
                quantMon = quantMon! + 0.5
            }
            labelMon.text = String(quantMon!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[0].status_msg)!)
        }
    }
    @IBAction func tueAdd(_ sender: Any) {
        if(productData?.product_quantity?[1].status == 1){
            if(quantTue != 20.0){
                quantTue = quantTue! + 0.5
            }
            labelTue.text = String(quantTue!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[1].status_msg)!)
        }
    }
    @IBAction func wedAdd(_ sender: Any) {
        if(productData?.product_quantity?[2].status == 1){
            if(quantWed != 20.0){
                quantWed = quantWed! + 0.5
            }
            labelWed.text = String(quantWed!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[2].status_msg)!)
        }
    }
    @IBAction func thuAdd(_ sender: Any) {
        if(productData?.product_quantity?[3].status == 1){
            if(quantThu != 20.0){
                quantThu = quantThu! + 0.5
            }
            labelThu.text = String(quantThu!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[3].status_msg)!)
        }
    }
    @IBAction func friAdd(_ sender: Any) {
        if(productData?.product_quantity?[4].status == 1){
            if(quantFri != 20.0){
                quantFri = quantFri! + 0.5
            }
            labelFri.text = String(quantFri!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[4].status_msg)!)
        }
    }
    @IBAction func satAdd(_ sender: Any) {
        if(productData?.product_quantity?[5].status == 1){
            if(quantSat != 20.0){
                quantSat = quantSat! + 0.5
            }
            labelSat.text = String(quantSat!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[5].status_msg)!)
        }
    }
    @IBAction func sunAdd(_ sender: Any) {
        if(productData?.product_quantity?[6].status == 1){
            if(quantSun != 20.0){
                quantSun = quantSun! + 0.5
            }
            labelSun.text = String(quantSun!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[6].status_msg)!)
        }
    }
    
    // MARK: - Button Sub Functions

    @IBAction func monSub(_ sender: Any) {
        if(productData?.product_quantity?[0].status == 1){
            if(quantMon != 0.0){
                quantMon = quantMon! - 0.5
            }
            labelMon.text = String(quantMon!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[0].status_msg)!)
        }
    }
    @IBAction func tueSub(_ sender: Any) {
        if(productData?.product_quantity?[1].status == 1){
            if(quantTue != 0.0){
                quantTue = quantTue! - 0.5
            }
            labelTue.text = String(quantTue!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[1].status_msg)!)
        }
    }
    @IBAction func wedSub(_ sender: Any) {
        if(productData?.product_quantity?[2].status == 1){
            if(quantWed != 0.0){
                quantWed = quantWed! - 0.5
            }
            labelWed.text = String(quantWed!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[2].status_msg)!)
        }
    }
    @IBAction func thuSub(_ sender: Any) {
        if(productData?.product_quantity?[3].status == 1){
            if(quantThu != 0.0){
                quantThu = quantThu! - 0.5
            }
            labelThu.text = String(quantThu!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[3].status_msg)!)
        }
    }
    @IBAction func friSub(_ sender: Any) {
        if(productData?.product_quantity?[4].status == 1){
            if(quantFri != 0.0){
                quantFri = quantFri! - 0.5
            }
            labelFri.text = String(quantFri!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[4].status_msg)!)
        }
    }
    @IBAction func satSub(_ sender: Any) {
        if(productData?.product_quantity?[5].status == 1){
            if(quantSat != 0.0){
                quantSat = quantSat! - 0.5
            }
            labelSat.text = String(quantSat!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[5].status_msg)!)
        }
    }
    @IBAction func sunSub(_ sender: Any) {
        if(productData?.product_quantity?[6].status == 1){
            if(quantSun != 0.0){
                quantSun = quantSun! - 0.5
            }
            labelSun.text = String(quantSun!)
        }else{
            alertError(title: "Oops!", msg: (productData?.product_quantity?[6].status_msg)!)
        }
    }
    @IBAction func ConfirmOrder(_ sender: Any) {
        if(quantSun != 0.0 || quantSat != 0.0 || quantFri != 0.0 || quantThu != 0.0 || quantWed != 0.0 || quantTue != 0 || quantMon != 0.0){
            let alertController = UIAlertController(title: "Confirm Custom Subscription", message: "Are you sure you want to edit the subscription?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.setDefaultFlag()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
           // alertError(title: "Error", msg: "Cannot add blank subscription")
        }
    }
    
    // MARK: - Api Call
    
    func editOrder() -> Void {
        showLoading(state: 1)
        quant = String(quantMon!) + "," + String(quantTue!) + "," + String(quantWed!) + "," + String(quantThu!) + "," + String(quantFri!) + "," + String(quantSat!) + "," + String(quantSun!)
        let params:[String:AnyObject] =
            [
                "subscription_type":sub_type as AnyObject,
                "product_id":productData?.product_id as AnyObject,
                "quantity_week":quant as AnyObject,
                "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject,
                "subscription_id":productData?.subscription_id as AnyObject,
                "make_default_flag": default_flag as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.editSubscription, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            print(response)
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
