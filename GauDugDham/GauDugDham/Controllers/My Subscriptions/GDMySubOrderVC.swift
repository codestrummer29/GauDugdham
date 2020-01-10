//
//  GDMySubOrderVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 30/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire

class GDMySubOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var order_array : [OrderData]?
    var sub_array : [SubscriptionData]?
    var pauseAction : UIAlertAction?

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var myControl: UISegmentedControl!
    @IBOutlet weak var tableSubOrder: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myControl.selectedSegmentIndex = 0;
        setUpTableView()
        loadsubData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myControl.selectedSegmentIndex = 0;
        loadsubData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segmented Control
    
    @IBAction func onSegmentChange(_ sender: Any) {
        self.tableSubOrder.reloadData()
    }
    // MARK: - Helpers
    
    func setUpTableView() -> Void {
        self.tableSubOrder.register(UINib(nibName:"GDMySubcell",bundle:nil), forCellReuseIdentifier: "GDMySubcell")
        self.tableSubOrder.register(UINib(nibName:"GDMyOrderCell",bundle:nil), forCellReuseIdentifier: "GDMyOrderCell")
    }
    
    func showOrderCancelOption(order_id : String) -> Void {
        let optionMenuController = UIAlertController(title: nil, message: "Do you want to cancel?", preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        
        let addAction = UIAlertAction(title: "Cancel Order", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.cancelOrder(order_id: order_id)
        })
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Close")
        })
        
        // Add UIAlertAction in UIAlertController
        
        optionMenuController.addAction(addAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        DispatchQueue.main.async {
            self.present(optionMenuController, animated: true, completion: nil)
        }
    }
    
    func showSubScriptionOptionS(sub_id:String, sub_status:String, sub_type:String ,data:SubscriptionData?) -> Void {
        let optionMenuController = UIAlertController(title: nil, message: "Subscription ID : " + sub_id, preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        
        let invoiceAction = UIAlertAction(title: "View Invoice", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("View")
            let vc : GDInvoiceVC = GDInvoiceVC()
            vc.sub_id = sub_id
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        let addAction = UIAlertAction(title: "Edit Subscription", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Edit")
            let vc : GDEditSubscriptionVC = GDEditSubscriptionVC()
            vc.sub_type = sub_type
            vc.productData = data
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        if(sub_status == "1"){
            pauseAction = UIAlertAction(title: "Pause Subscription", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Pause")
                self.changeSubStatus(sub_id: sub_id, status: "2")
            })
        }else{
            pauseAction = UIAlertAction(title: "Resume Subscription", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Pause")
                self.changeSubStatus(sub_id: sub_id, status: "1")
            })
        }
        
        let removeAction = UIAlertAction(title: "Cancel Subscription", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.changeSubStatus(sub_id: sub_id, status: "0")
        })
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Close")
        })
        
        if(sub_type != "3"){
            addAction.isEnabled = false
        }
        if(sub_status == "0"){
            addAction.isEnabled = false
            pauseAction?.isEnabled = false
            removeAction.isEnabled = false
        }
        
        // Add UIAlertAction in UIAlertController
        optionMenuController.addAction(invoiceAction)
        optionMenuController.addAction(addAction)
        optionMenuController.addAction(pauseAction!)
        optionMenuController.addAction(removeAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        DispatchQueue.main.async {
            self.present(optionMenuController, animated: true, completion: nil)
        }

    }
    
    func alertError(title : String,msg : String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegates and Datasourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(myControl.selectedSegmentIndex == 0){
            if(sub_array != nil){
                return (sub_array?.count)!
            }else{
                return 0
            }
        }else{
            if(order_array != nil){
                return (order_array?.count)!
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(myControl.selectedSegmentIndex == 0){
            let cell = tableSubOrder.dequeueReusableCell(withIdentifier:"GDMySubcell", for: indexPath) as! GDMySubcell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if(sub_array != nil){
                cell.updateDate(data: sub_array?[indexPath.row])
            }
            return cell
        }else{
            let cell = tableSubOrder.dequeueReusableCell(withIdentifier:"GDMyOrderCell", for: indexPath) as! GDMyOrderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if(order_array != nil){
                cell.updateData(data: order_array?[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(myControl.selectedSegmentIndex == 0){
            return 160
        }else{
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(myControl.selectedSegmentIndex == 0){
            //subscription
            showSubScriptionOptionS(sub_id: (sub_array?[indexPath.row].subscription_id!)!, sub_status: (sub_array?[indexPath.row].subscription_status)! , sub_type:(sub_array?[indexPath.row].subscription_type!)!,data: sub_array?[indexPath.row])
        }else{
            //order
            if(order_array?[indexPath.row].order_status == "1"){
                showOrderCancelOption(order_id: (order_array?[indexPath.row].order_id!)!)
            }
        }
    }

    // MARK: - Api Call
    
    func loadsubData() -> Void {
        tableSubOrder.isHidden = true
        loadingBar.startAnimating()
        let params:[String:AnyObject] =
                [
                "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject
                ]
        Alamofire.request(Constants.ApiUrl.getOrders, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject
            {(response : DataResponse<GDSubOrderResponse>) in
                self.loadingBar.stopAnimating()
                self.tableSubOrder.isHidden = false
                if response.result.isSuccess{
                    let data = response.result.value
                    if(data?.status == 1){
                        self.order_array = data?.orders
                        self.sub_array = data?.subscriptions
                        self.tableSubOrder.reloadData()
                    }else{
                        //fail from server
                        self.alertError(title: "Error!", msg: "Could not load data please try again later")
                    }
                }else{
                    //no net
                    self.alertError(title: "Error!", msg: "Please check your internet connection and try again later")
                }
        }
    }
    
    func cancelOrder(order_id : String) -> Void {
        tableSubOrder.isHidden = true
        loadingBar.startAnimating()
        let params:[String:AnyObject] =
        [
            "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject,
            "order_id":order_id as AnyObject,
            "order_status":"0" as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.cancelOrder, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            self.tableSubOrder.isHidden = false
            self.loadingBar.stopAnimating()
            if response.result.isSuccess{
                if let data = response.result.value as? [String:AnyObject] {
                    if (data["status"]?.isEqual(1))!{
                        self.loadsubData()
                        self.tableSubOrder.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }else{
                        //failed
                        self.alertError(title: "Error!", msg: "Could not cancel subscription status please try again later")
                    }
                }
            }else{
                // no internet
                self.alertError(title: "Error!", msg: "Please check your internet connection and try again later")
            }
        }
    }
    
    func changeSubStatus(sub_id : String , status : String) -> Void {
        tableSubOrder.isHidden = true
        loadingBar.startAnimating()
        let params:[String:AnyObject] =
        [
            "uid":UserDefaults.standard.value(forKey: Constants.LoginIdentifiers.userLoginTokenKey) as AnyObject,
            "subscription_id":sub_id as AnyObject,
            "subscription_status":status as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.changeSubStatus, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            self.tableSubOrder.isHidden = false
            self.loadingBar.stopAnimating()
            if response.result.isSuccess{
                if let data = response.result.value as? [String:AnyObject] {
                    if (data["status"]?.isEqual(1))!{
                        self.loadsubData()
                        self.tableSubOrder.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }else{
                        //failed
                        self.alertError(title: "Error!", msg: "Could not change subscription status please try again later")
                    }
                }
            }else{
                // no internet
                 self.alertError(title: "Error!", msg: "Please check your internet connection and try again later")
            }

        }
    }
}
