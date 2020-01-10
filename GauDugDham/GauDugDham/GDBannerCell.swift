//
//  GDBannerCell.swift
//  GauDugDham
//
//  Created by Saahil Gilani on 12/03/17.
//  Copyright © 2017 Saahil Gilani. All rights reserved.
//

import UIKit

class GDBannerCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var bannerArray: [BannerData]?
    @IBOutlet weak var collectionBanner: UICollectionView!
    @IBOutlet weak var pagerTab: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pagerTab.currentPage = 0
    }
    
    func updateData(data : [BannerData]) -> Void {
        bannerArray = data;
        setUpPageMarker()
        setUpCollectionView()
        
        collectionBanner.delegate = self;
        collectionBanner.dataSource = self;
        collectionBanner.reloadData()
        self.pagerTab.numberOfPages = (bannerArray?.count)!

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Collection View Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bannerArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionBanner.dequeueReusableCell(withReuseIdentifier: "GDBannerImageCell", for: indexPath) as! GDBannerImageCell
        cell.getImage(img: (bannerArray?[indexPath.row].banner_image_url)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pagerTab.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // pagerTab.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width,height :collectionBanner.bounds.height);
    }
    
    // MARK: - Helpers
    
    func setUpCollectionView() -> Void {
        self.collectionBanner.register(UINib(nibName:"GDBannerImageCell",bundle:nil), forCellWithReuseIdentifier:"GDBannerImageCell")
    }
    
    func setUpPageMarker() -> Void {
        self.pagerTab.numberOfPages = (bannerArray?.count)!
    }
    
}
