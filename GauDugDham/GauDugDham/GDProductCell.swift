//
//  GDProductCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 22/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDProductCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var productArray : [ProductCategoryData]?
    @IBOutlet weak var collectionProduct: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helpers
    
    func updateData(data : [ProductCategoryData]) -> Void {
        productArray = data
        setUpCollectionView()
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        collectionProduct.reloadData()
    }
    
    func setUpCollectionView() -> Void {
         self.collectionProduct.register(UINib(nibName:"GDProductDataCell",bundle:nil), forCellWithReuseIdentifier:"GDProductDataCell")
    }
    
    // MARK: - Collection View Delegates and Datasourse
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (productArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionProduct.dequeueReusableCell(withReuseIdentifier: "GDProductDataCell", for: indexPath) as! GDProductDataCell
        cell.getData(data: productArray?[indexPath.row])
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : UIScreen.main.bounds.width/2, height : 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        let vc : GDProductViewVC = GDProductViewVC()
        vc.c_id = productArray?[indexPath.row].category_id
        vc.nav_title = productArray?[indexPath.row].category_type
//        self.window?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}
