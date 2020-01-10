//
//  GDChangeDetailsVc.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 27/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
class GDChangeDetailsVc: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var textAddress: UITextView!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textPincode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textCity.delegate = self
        textPincode.delegate = self
        textAddress.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func butSubmit(_ sender: Any) {
        loadingBar.startAnimating()
        let add = textAddress.text
        let city = textCity.text
        let pin = textPincode.text
        let m_number = UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber)
        let params:[String:AnyObject] =
            [
                "mobile_no":m_number as AnyObject,
                "address":add as AnyObject,
                "city":city as AnyObject,
                "pincode":pin as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.add_change, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            if response.result.isSuccess{
                if let data = response.result.value as? [String:AnyObject]{
                    if(data["status"]?.isEqual(1))!{
                        let defaults = UserDefaults.standard
                        defaults.set(add, forKey: Constants.UserDetails.address)
                        defaults.set(city, forKey: Constants.UserDetails.city)
                        defaults.set(pin, forKey: Constants.UserDetails.pincode)
                        defaults.synchronize()
                        self.tryAgainLater(msg: data["msg"] as! String)
                    }else{
                        // error
                        self.tryAgainLater(msg: data["msg"] as! String)
                    }
                }
            }else{
                //no net //server fail
                self.tryAgainLater(msg: "Please try again after some time")
            }
        }
    }
    
    func tryAgainLater(msg : String) -> Void {
        loadingBar.stopAnimating()
        let alert = UIAlertController(title: "Alert!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
