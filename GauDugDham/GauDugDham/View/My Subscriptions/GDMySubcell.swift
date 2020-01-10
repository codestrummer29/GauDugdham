//
//  GDMySubcell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 30/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage

class GDMySubcell: UITableViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSId: UILabel!
    @IBOutlet weak var viewSubStatus: UIView!
    @IBOutlet weak var labelSubStatus: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var labelSubType: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDate(data : SubscriptionData?) -> Void {
        imageProduct.sd_setImage(with: URL(string:(data?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        labelPrice.text = "Rs " + (data?.product_price)! + "/ " + (data?.product_quantity_unit)!
        labelName.text = data?.product_name
        labelSId.text = data?.time
        if(data?.subscription_status == "1"){
            labelSubStatus.text = "Active"
            viewSubStatus.backgroundColor = Constants.Colors.Green
        }else if(data?.subscription_status == "2"){
            labelSubStatus.text = "Inactive"
            viewSubStatus.backgroundColor = Constants.Colors.Red
        }else{
            labelSubStatus.text = "Cancelled"
            viewSubStatus.backgroundColor = Constants.Colors.AppColor
        }
        if(data?.subscription_type == "1"){
            labelSubType.text = "Type : Daily" + " (" + (data?.product_quantity?[0].quantity)! + " " + (data?.product_quantity_unit)! + ")"
        }else if(data?.subscription_type == "2"){
            if(data?.product_quantity?[0].quantity == "0"){
                  labelSubType.text = "Type : Alternate days" + " (" + (data?.product_quantity?[1].quantity)! + " " + (data?.product_quantity_unit)! + ")"
            }else{
                labelSubType.text = "Type : Alternate days" + " (" + (data?.product_quantity?[0].quantity)! + " " + (data?.product_quantity_unit)! + ")"
            }
        }else{
            labelSubType.text = "Type : Custom (Editable)"
        }
    }
    
}
