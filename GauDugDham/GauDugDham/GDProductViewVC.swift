//
//  GDProductViewVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 01/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class GDProductViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var tableProdView: UITableView!
    var c_id : String?
    var nav_title: String?
    var product_array : [ProductData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.showTable(value: false)
        navTitle.title = nav_title
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(GDProductViewVC.close))
        navTitle.leftBarButtonItem = closeButton
        self.setUpTableView()
        self.getProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegates and Datasourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(product_array != nil){
            return (product_array?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableProdView.dequeueReusableCell(withIdentifier:"GDProductViewCell", for: indexPath) as! GDProductViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if(product_array != nil){
            cell.getData(data: product_array?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(product_array?[indexPath.row].product_subscribable == "0"){
            print("click sub no")
            let vc : GDProductPageVC = GDProductPageVC()
            vc.productData = product_array?[indexPath.row]
            DispatchQueue.main.async {
                //self.present(vc, animated: true, completion: nil)
                self.show(vc, sender: nil)
            }
        }else if(product_array?[indexPath.row].product_subscribable == "1"){
            print("click sub yes")
            // Create An UIAlertController with Action Sheet
            
            let optionMenuController = UIAlertController(title: nil, message: "Select Subscription Type", preferredStyle: .actionSheet)
            
            // Create UIAlertAction for UIAlertController
            
            let addAction = UIAlertAction(title: "Daily", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Daily")
                let vc : GDSubscribeVC = GDSubscribeVC()
                vc.productData = self.product_array?[indexPath.row]
                vc.sub_status = "1"
                DispatchQueue.main.async {
                    //self.present(vc, animated: true, completion: nil)
                    self.show(vc, sender: nil)
                }
            })
            let saveAction = UIAlertAction(title: "Alternate Days", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Alter")
                let vc : GDSubscribeVC = GDSubscribeVC()
                vc.productData = self.product_array?[indexPath.row]
                vc.sub_status = "2"
                DispatchQueue.main.async {
                    //self.present(vc, animated: true, completion: nil)
                    self.show(vc, sender: nil)
                }
            })
            
            let deleteAction = UIAlertAction(title: "Custom", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Custom")
                let vc : GDSubscribeCusVC = GDSubscribeCusVC()
                vc.productData = self.product_array?[indexPath.row]
                vc.sub_status = "3"
                DispatchQueue.main.async {
                    //self.present(vc, animated: true, completion: nil)
                    self.show(vc, sender: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            // Add UIAlertAction in UIAlertController
            
            optionMenuController.addAction(addAction)
            optionMenuController.addAction(saveAction)
            optionMenuController.addAction(deleteAction)
            optionMenuController.addAction(cancelAction)
            
            // Present UIAlertController with Action Sheet
            DispatchQueue.main.async {
                self.present(optionMenuController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    func setUpTableView() -> Void {
        self.tableProdView.register(UINib(nibName:"GDProductViewCell",bundle:nil), forCellReuseIdentifier: "GDProductViewCell")
    }
    
    func close() -> Void {
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    func showTable(value : Bool) -> Void {
        if(value == true){
            tableProdView.isHidden = false
            loadingBar.stopAnimating()
        }else{
            tableProdView.isHidden = true
            loadingBar.startAnimating()
        }
    }
    

    // MARK: - Api Call
    
    func getProducts() -> Void {
        let params:[String:AnyObject] =
            [
                "category_id":c_id as AnyObject,
            ]

        Alamofire.request(Constants.ApiUrl.product_page, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject
            { (response :DataResponse<ProductViewData> ) in
                if response.result.isSuccess{
                    let data = response.result.value
                    if (data?.status == 1){
                        self.product_array = data?.products_data
                        self.tableProdView.reloadData()
                        self.showTable(value: true)
                    }else{
                        // server error
                    }
                }else{
                    // no net / fail // gg
                }
        };
    }

}
