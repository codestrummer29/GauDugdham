//
//  GDInvoiceVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 07/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire

class GDInvoiceVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var sub_id : String?
    var invoice_data : InvoiceData?

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var tableInvoice: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTableView()
        loadInvoiceData()
        tableInvoice.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func setUpTableView() -> Void {
        self.tableInvoice.register(UINib(nibName:"GDInvoiceDataCell",bundle:nil), forCellReuseIdentifier: "GDInvoiceDataCell")
        self.tableInvoice.register(UINib(nibName:"GDNoInvoiceCell",bundle:nil), forCellReuseIdentifier: "GDNoInvoiceCell")
        self.tableInvoice.register(UINib(nibName:"GDInvoiceMonthCell",bundle:nil), forCellReuseIdentifier: "GDInvoiceMonthCell")
    }
    
    func alertError(title : String,msg : String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegates and Datasourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(invoice_data?.quantity_by_month != nil){
            return (invoice_data?.quantity_by_month?.count)! + 1
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(invoice_data?.quantity_by_month != nil){
            if(indexPath.row == 0){
                let cell = tableInvoice.dequeueReusableCell(withIdentifier:"GDInvoiceDataCell", for: indexPath) as! GDInvoiceDataCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.updateCellWithData(data: invoice_data, sub_id: sub_id)
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 0.5
                return cell
            }else{
                let cell = tableInvoice.dequeueReusableCell(withIdentifier:"GDInvoiceMonthCell", for: indexPath) as! GDInvoiceMonthCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.updateCellWithData(data:invoice_data?.quantity_by_month?[indexPath.row - 1],unit :invoice_data?.product_quantity_unit)
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 0.5
                return cell
            }
        }else{
            let cell = tableInvoice.dequeueReusableCell(withIdentifier:"GDNoInvoiceCell", for: indexPath) as! GDNoInvoiceCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 280
        }else{
            return 70
        }
    }
    
    // MARK: - Api Call
    
    func loadInvoiceData() -> Void {
        loadingBar.startAnimating()
        let params:[String:AnyObject] =
            [
                "subscription_id":sub_id as AnyObject
        ]
        Alamofire.request(Constants.ApiUrl.getInvoice, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject
            {(response : DataResponse<Invoice>) in
                self.loadingBar.stopAnimating()
                self.tableInvoice.isHidden = false
                if response.result.isSuccess{
                    let data = response.result.value
                    if(data?.status == 1){
                        self.invoice_data = data?.subscription_invoice_data
                        self.tableInvoice.reloadData()
                    }else{
                        //error
                        self.alertError(title: "Error!", msg: "Could not load Invoice. Please try again later")
                    }
                }else{
                    //fail
                    self.alertError(title: "Error!", msg: "Please check your internet connection and try again later")
                }
                self.tableInvoice.reloadData()
        }
    }
    
}
