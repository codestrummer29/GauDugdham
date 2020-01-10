//
//  GDChangeNumberVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 27/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
class GDChangeNumberVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textOld: UITextField!
    @IBOutlet weak var textNew: UITextField!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    var textField : UITextField!
    var otp = ""
    var enteredOTP = "",number="",numberNew=""
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textOld.delegate = self
        textNew.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action

    @IBAction func butVerify(_ sender: Any) {
        self.verifyOtpMSg()
    }
    
    // MARK: - Helpers
    
    func verifyOtpMSg() -> Void {
        loadingBar.startAnimating()
        number = textOld.text!
        numberNew = textNew.text!
        print(number.characters.count + numberNew.characters.count)
        if (number.characters.count==10 && number == (UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber)as! String) && numberNew.characters.count==10){

            let parameters: [String: AnyObject] =
                [
                    "mobile_no": numberNew as AnyObject,
            ]
            Alamofire.request(Constants.ApiUrl.sendOtp, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if response.result.isSuccess{
                    if let data = response.result.value as? [String:AnyObject]{
                        if (data["status"]?.isEqual(1))!{
                            self.otp = data["otp"] as! String
                            self.showOTPVerify()
                        }else{
                            //failed from otp server
                            self.tryAgainLater(msg: "Please try again after some time")
                        }
                    }
                }else{
                    // no internet/etc not success
                    self.tryAgainLater(msg: "Please try again after some time")
                }
            }
        }else{
            //blank / incorrect details
            self.tryAgainLater(msg: "Enter Correct Mobile Number")
        }
    }
    
    
    func showOTPVerify() -> Void {
        loadingBar.stopAnimating()
        let alertController = UIAlertController(title: "Verify OTP", message: "Enter the OTP sent on the mobile number you entered above", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.enteredOTP = field.text!
                if(self.otp == self.enteredOTP){
                    //verified
                    self.changeNumber()
                    self.loadingBar.startAnimating()
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
    
    func tryAgainLater(msg : String) -> Void {
        loadingBar.stopAnimating()
        let alert = UIAlertController(title: "Alert!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Api Call
    
    func changeNumber() -> Void {
        let params: [String: AnyObject] =
            [
                "new_mobile_no": numberNew as AnyObject,
                "old_mobile_no": number as AnyObject,
        ]
        Alamofire.request(Constants.ApiUrl.mobile_change, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            if response.result.isSuccess{
                if let data = response.result.value as? [String : AnyObject]{
                    if(data["status"]?.isEqual(1))!{
                        let defaults = UserDefaults.standard
                        defaults.set(self.numberNew, forKey: Constants.UserDetails.mobileNumber)
                        defaults.synchronize()
                        self.tryAgainLater(msg: data["msg"] as! String)
                    }else{
                        // some error
                        self.tryAgainLater(msg: data["msg"] as! String)
                    }
                }
            }else{
                //fail /no net
                self.tryAgainLater(msg: "Please try again after some time")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
