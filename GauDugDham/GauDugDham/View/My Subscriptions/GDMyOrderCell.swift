//
//  GDMyOrderCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 01/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDMyOrderCell: UITableViewCell {
    
    var x : Int?
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQuant: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelEdit: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(data : OrderData?) -> Void {
        imageProduct.sd_setImage(with: URL(string:(data?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        productName.text = data?.product_name
        labelPrice.text = "Rs " + String(describing: (data?.total_price)!)
        labelQuant.text = "Quantity : " + (data?.product_quantity)!
        labelEdit.isHidden = false
        if(data?.order_status == "0"){
            labelStatus.text = "Cancelled"
            viewStatus.backgroundColor = Constants.Colors.Red
            labelEdit.isHidden = true
        }else if(data?.order_status == "1"){
            labelStatus.text = "Placed"
            viewStatus.backgroundColor = Constants.Colors.AppColor
        }else{
            labelStatus.text = "Delivered"
            viewStatus.backgroundColor = Constants.Colors.Green
        }
        labelTime.text = data?.time
    }
    
}
