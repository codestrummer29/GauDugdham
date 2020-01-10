//
//  GDProductDataCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 22/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage

class GDProductDataCell: UICollectionViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getData(data : ProductCategoryData?) -> Void {
        labelName.text = data?.category_type
        imageProduct.sd_setImage(with: URL(string:(data?.category_img)!), placeholderImage: UIImage(named: "placeholder"))
    }

}
