//
//  GDInvoiceDataCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 07/05/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDInvoiceDataCell: UITableViewCell {
    @IBOutlet weak var labelSubId: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelSubid: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithData(data : InvoiceData? , sub_id : String?) -> Void {
        labelDate.text = data?.subscription_created_date
        labelName.text = data?.product_name
        labelPrice.text = "Rs " + (data?.product_price)! + "/" + (data?.product_quantity_unit)!
        labelSubId.text = sub_id
        labelSubid.text = sub_id
        var amount : Float?
        amount = 0.0
        for price in (data?.quantity_by_month)!{
            amount = amount! + Float(price.total_amount!)!
        }
        labelTotal.text = "Rs " + String(amount!)
    }
    
}
