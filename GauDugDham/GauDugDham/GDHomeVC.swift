//
//  GDHomeVC.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class GDHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var tableHome: UITableView!
    var banner_array: [BannerData]?
    var product_category_array : [ProductCategoryData]?
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingBar.startAnimating()
        tableHome.isHidden = true
        self.setUpTableView()
        self.loadHomePageData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegates and Datasourse
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableHome.dequeueReusableCell(withIdentifier:"GDBannerCell", for: indexPath) as! GDBannerCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if(banner_array != nil){
                cell.updateData(data: banner_array!)
            }
            return cell
        }else{
            let cell = tableHome.dequeueReusableCell(withIdentifier: "GDProductCell", for: indexPath) as! GDProductCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if(product_category_array  != nil){
                cell.updateData(data: product_category_array!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 220
        }else{
            if(product_category_array?.count != nil){
                let x = product_category_array?.count ?? 0
                if((product_category_array?.count)! % 2 == 0){
                    return CGFloat(x/2 as Int)*180
                }else{
                    return CGFloat((x+1)/2 as Int)*180
                }
            }else{
                return 150
            }
        }
    }
    
    // MARK: - Helpers
    
    func setUpTableView() -> Void {
        self.tableHome.register(UINib(nibName:"GDBannerCell",bundle:nil), forCellReuseIdentifier: "GDBannerCell")
        self.tableHome.register(UINib(nibName:"GDProductCell",bundle:nil), forCellReuseIdentifier: "GDProductCell")
    }
    // MARK: - Api Call
    
    func loadHomePageData() -> Void {
        Alamofire.request(Constants.ApiUrl.home_page, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response :DataResponse<GDHomeResponse> ) in
            if response.result.isSuccess{
                let data = response.result.value
                if(data?.status == 1){
                    self.banner_array = data?.banner_data
                    self.product_category_array = data?.product_category_data
                    self.tableHome.reloadData()
                    self.loadingBar.stopAnimating()
                    self.tableHome.isHidden = false
                }else{
                    //server error //unauthorised
                }
            }else{
                //no internet // server fail
            }
        }
    }
}
