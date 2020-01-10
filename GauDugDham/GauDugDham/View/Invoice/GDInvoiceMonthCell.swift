//
//  GDInvoiceMonthCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 13/08/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDInvoiceMonthCell: UITableViewCell {

    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelQuant: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithData(data : ProductMonthData?, unit: String?){
        labelMonth.text = data?.date
        labelQuant.text = (data?.total_quantity)! + " " + unit!
        labelPrice.text = "Rs " + (data?.total_amount)!
    }
}
