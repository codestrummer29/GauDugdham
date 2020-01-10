//
//  GDLoginVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
class GDLoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var back: UINavigationItem!
    @IBOutlet weak var labelNumber: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backbutton = UIBarButtonItem(title: "Close", style: .plain, target: self, action:#selector(GDLoginVC.hitBack))
        self.back.setLeftBarButton(backbutton, animated: false)
        self.loading(state: false)
        labelNumber.delegate = self
        labelPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api Call
    
    @IBAction func loginAction(_ sender: Any) {
        self.loading(state: true)
        var number = labelNumber.text
        var pass = labelPassword.text
        if(number?.characters.count == 10 && pass?.characters.count != 0){
            let params:[String:AnyObject] =
                [
                "mobile_no":number as AnyObject,
                "password":pass as AnyObject
                ]
            Alamofire.request(Constants.ApiUrl.login, method:.post , parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
                if response.result.isSuccess{
                    if let data = response.result.value as? [String:AnyObject] {
                        if (data["status"]?.isEqual(1))!{
                            let defaults = UserDefaults.standard
                            defaults.set(data["user_data"]?["address"]!, forKey: Constants.UserDetails.address)
                            defaults.set(data["user_data"]?["city"]!, forKey: Constants.UserDetails.city)
                            defaults.set(data["user_data"]?["pincode"]!, forKey: Constants.UserDetails.pincode)
                            defaults.set(data["user_data"]?["uid"]!, forKey: Constants.LoginIdentifiers.userLoginTokenKey)
                            defaults.set(data["user_data"]?["name"]!, forKey: Constants.UserDetails.name)
                            defaults.set(data["user_data"]?["mobile_no"]!, forKey: Constants.UserDetails.mobileNumber)
                            defaults.synchronize()
                            self.makeTabBar()
                        }else{
                            //incorrect details/ server error
                            self.alertError(msg: data["msg"] as! String)
                        }
                    }
                }else{
                    //not success
                    self.alertError(msg: "Please try again after some time")
                }
            }
        }else{
            // enter correct details
            self.alertError(msg: "Enter valid mobile number and password")
        }
    }
    
    // MARK: - Helpers
    
    func makeTabBar() -> Void {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "GDTabControllerVC") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func hitBack() -> Void {
        dismiss(animated: true, completion: nil)
    }
    
    func alertError(msg : String) -> Void {
        self.loading(state: false)
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
}
