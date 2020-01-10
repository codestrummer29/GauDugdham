//
//  GDRegisterVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire

class GDRegisterVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textMobile: UITextField!
    @IBOutlet weak var back: UINavigationItem!
    @IBOutlet weak var textPass: UITextField!
    var textField : UITextField!
    var otp = ""
    var enteredOTP = "",name="",number="",pass=""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backbutton = UIBarButtonItem(title: "Close", style: .plain, target: self, action:#selector(GDLoginVC.hitBack))
        self.back.setLeftBarButton(backbutton, animated: false)
        self.loading(state: false)
        textName.delegate = self
        textMobile.delegate = self
        textPass.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api Call
    
    @IBAction func verifyOTP(_ sender: Any) {
//        self.loading(state: true)
//        number = textMobile.text!
//        if(number.characters.count == 10){
//            let params: [String: AnyObject] =
//                [
//                    "mobile_no": number as AnyObject
//                ]
//            Alamofire.request(Constants.ApiUrl.verify_number, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {response in
//                if response.result.isSuccess{
//                    if let data = response.result.value as? [String:AnyObject]{
//                        if(data["status"]?.isEqual(1))!{
                            self.verifyOtpMSg()
//                            self.loading(state: false)
//                        }else{
//                            //failed / already exist
//                            self.tryAgainLater(msg: data["msg"] as! String)
//                        }
//                    }
//                }else{
//                    // no internet/no response
//                    self.tryAgainLater(msg: "Please try again after some time")
//                }
//            }
//        }else{
//            //incorrect number
//            self.tryAgainLater(msg: "Enter 10 digit mobile number")
//        }
    }
    
    // MARK: - Verify OTP
    
    func verifyOtpMSg() -> Void {
        self.loading(state: true)
        name = textName.text!
        number = textMobile.text!
        pass = textPass.text!
        if (name.characters.count != 0 && pass.characters.count != 0 && number.characters.count==10){
            let parameters: [String: AnyObject] =
                [
                    "mobile_no": number as AnyObject,
                ]
            Alamofire.request(Constants.ApiUrl.sendOtp, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if response.result.isSuccess{
                    if let data = response.result.value as? [String:AnyObject]{
                        if (data["status"]?.isEqual(1))!{
                            self.otp = data["otp"] as! String
                            self.showOTPVerify()
                        }else{
                            //failed from otp server
                            self.tryAgainLater(msg: data["msg"] as! String)
                        }
                    }
                }else{
                    // no internet/etc not success
                    self.tryAgainLater(msg: "Please try again after some time")
                }
            }
        }else{
            //blank / incorrect details
            self.tryAgainLater(msg: "Enter Correct Details")
        }
    }
    
    func showOTPVerify() -> Void {
        self.loading(state: false)
        let alertController = UIAlertController(title: "Verify OTP", message: "Enter the OTP sent on the mobile number you entered above", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.enteredOTP = field.text!
                if(self.otp == self.enteredOTP){
                    //verified
                    let defaults = UserDefaults.standard
                    defaults.set(self.name, forKey: Constants.UserDetails.name)
                    defaults.set(self.number, forKey: Constants.UserDetails.mobileNumber)
                    defaults.set(self.pass, forKey: Constants.UserDetails.password)
                    defaults.synchronize()
                    let vc : GDUserDetailsVC = GDUserDetailsVC()
                    self.present(vc, animated: true, completion: nil)
                }else{
                    //incorrect OTP
                    alertController.message = "Incorrect OTP entered"
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                // user did not fill field
                alertController.message = "Please enter OTP"
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter OTP"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func hitBack() -> Void {
        dismiss(animated: true, completion: nil)
    }
    
    func tryAgainLater(msg : String) -> Void {
        self.loading(state: false)
        let alert = UIAlertController(title: "Oops!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loading(state : Bool) -> Void {
        if (state == false){
            loadingBar.stopAnimating()
            loadingBar.isHidden = true
        }else{
            loadingBar.startAnimating()
            loadingBar.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
