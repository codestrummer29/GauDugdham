//
//  GDProductViewCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 01/04/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage
class GDProductViewCell: UITableViewCell {

    @IBOutlet weak var imagePRoduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getData(data : ProductData?) -> Void {
        imagePRoduct.sd_setImage(with: URL(string:(data?.product_img_url)!), placeholderImage: UIImage(named: "placeholder"))
        labelTitle.text = data?.product_name
        labelPrice.text = "Rs "+(data?.product_price)! + "/" + (data?.product_price_quantity)!+(data?.product_quantity_unit)!
        if(data?.product_subscribable == "1"){
            labelType.text = "Subscribe"
        }else{
            labelType.text = "Order"
        }
    }
}
