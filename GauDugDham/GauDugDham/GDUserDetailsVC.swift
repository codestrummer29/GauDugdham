//
//  GDUserDetailsVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
class GDUserDetailsVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var textAddress: UITextView!
    @IBOutlet weak var textPincode: UITextField!
    @IBOutlet weak var textCity: UITextField!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading(state: false)
        textAddress.delegate = self
        textPincode.delegate = self
        textCity.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api Call

    @IBAction func submitRegister(_ sender: Any) {
        loading(state: true)
        let add = textAddress.text
        let city = textCity.text
        let pin = textPincode.text
        let name = UserDefaults.standard.value(forKey: Constants.UserDetails.name)
        let m_number = UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber)
        let pass = UserDefaults.standard.value(forKey: Constants.UserDetails.password)
        if (add?.characters.count != 0 && city?.characters.count != 0 && pin?.characters.count != 0){
            let params:[String:AnyObject] =
                [
                    "mobile_no":m_number as AnyObject,
                    "password":pass as AnyObject,
                    "name":name as AnyObject,
                    "address":add as AnyObject,
                    "city":city as AnyObject,
                    "pincode":pin as AnyObject
                ]
            Alamofire.request(Constants.ApiUrl.register, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
                print(response)
                if response.result.isSuccess{
                    if let data = response.result.value as? [String:AnyObject]{
                        if(data["status"]?.isEqual(1))!{
                            //success
                            let defaults = UserDefaults.standard
                            defaults.set(add, forKey: Constants.UserDetails.address)
                            defaults.set(city, forKey: Constants.UserDetails.city)
                            defaults.set(pin, forKey: Constants.UserDetails.pincode)
                            defaults.set(data["uid"], forKey: Constants.LoginIdentifiers.userLoginTokenKey)
                            defaults.synchronize()
                            self.makeTabBar()
                        }else{
                            //Error status != 1
                            self.alertError(msg: data["msg"] as! String)
                        }
                    }
                }else{
                    //no internet // no server response
                    self.alertError(msg: "Please try again after some time.")
                }
            }
        }else{
            //incorrect details
            self.alertError(msg: "Enter correct details")
        }
    }
    
    // MARK: - Helpers
    
    func makeTabBar() -> Void {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "GDTabControllerVC") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func alertError(msg : String) -> Void {
        loading(state: false)
        let alert = UIAlertController(title: "Error!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
    
    func textViewShouldReturn(_ textField: UITextView) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
