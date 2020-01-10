//
//  GDProfileVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 25/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire

class GDProfileVC: UIViewController {

    @IBOutlet weak var labelOrders: UILabel!
    @IBOutlet weak var labelSubs: UILabel!
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button1 = UIBarButtonItem(title :"Logout", style: .plain, target: self, action: #selector(GDProfileVC.logout)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        labelSubs.isHidden = true
        labelOrders.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        labelAddress.text = UserDefaults.standard.value(forKey: Constants.UserDetails.address) as? String
        getProfData()
        let name = UserDefaults.standard.value(forKey: Constants.UserDetails.name) as? String
        let mobile = UserDefaults.standard.value(forKey: Constants.UserDetails.mobileNumber) as? String
        labelWelcome.text = String(name! + "\n" + mobile!)
    }
    
    // MARK: - Button Actions
    
    @IBAction func butChangeNo(_ sender: Any) {
        let vc : GDChangeNumberVC = GDChangeNumberVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func butChangeAdd(_ sender: Any) {
        let vc : GDChangeDetailsVc = GDChangeDetailsVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logout() -> Void {
        
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            let vc = GDLoginSignUpSelectVC(nibName: "GDLoginSignUpSelectVC", bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api Call
    
    func getProfData() -> Void {
        let params:[String:AnyObject] =
            [
                "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as? String as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.getProfileData, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject
            {(response : DataResponse<ProfileResponse>) in
                if response.result.isSuccess{
                    let data = response.result.value
                    print(data ?? "0")
                    if(data?.status == 1){
                        self.labelOrders.text = (data?.order_count)! + " " + "Orders"
                        self.labelSubs.text = (data?.subscription_count)! + " " + "Subscriptions"
                        self.labelSubs.isHidden = false
                        self.labelOrders.isHidden = false
                    }
                }
        }
        
    }
    
}
