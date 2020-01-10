//
//  GDBannerImageCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit
import SDWebImage
class GDBannerImageCell: UICollectionViewCell {

    @IBOutlet weak var imageBanner: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getImage(img : String) -> Void {
        print("hello" + img)
        imageBanner.sd_setImage(with: URL(string:(img)), placeholderImage: UIImage(named: "placeholder"))
    }

}
