//
//  LivePhotoDetailViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/21.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class LivePhotoDetailViewController: UIViewController {
    
    var selectedSubCategoryId: Int?
    
    var livePhotoManager: LivePhotoManager!
    
    var livePhotoView: PHLivePhotoView!
    var saveButton: UIButton!
    var favoriteButton: UIButton!
    var moreButton: UIButton!
    var collectionView: UICollectionView!
    
    var pageIndex = 0
    
    var dataSource = [LivePhotoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        livePhotoManager = LivePhotoManager()
        self.view.backgroundColor = UIColor.white
        self.setupContentView()
        self.updateSelectedSubCategoryId(id: 1001)
    }
    
    public func updateSelectedSubCategoryId(id: Int) {
        selectedSubCategoryId = id
        self.refreshDataSource()
    }
    
    private func refreshDataSource() {
        pageIndex = 0
        dataSource.removeAll()
        self.loadMoreLivePhotos()
    }
    
    private func loadMoreLivePhotos() {
        guard let categoryId = selectedSubCategoryId else {
            return
        }
        LivePhotoNetworkHelper.requestLivePhotoList(in: categoryId, at: pageIndex) { [weak self] (livePhotos) in
            if let list = livePhotos {
                self?.dataSource.append(contentsOf: list)

                self?.pageIndex += 1
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupContentView() {
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UINib.init(nibName: "LivePhotoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "livephotodetailCell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .gray
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        saveButton = UIButton(frame: .zero)
        saveButton.backgroundColor = UIColor.gray
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(60)
        }
        
        moreButton = UIButton(frame: .zero)
        moreButton.backgroundColor = UIColor.gray
        self.view.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(saveButton.snp.centerY)
            make.right.equalTo(saveButton.snp.left).offset(-20)
            make.width.height.equalTo(30)
        }
        
        favoriteButton = UIButton(frame: .zero)
        favoriteButton.backgroundColor = UIColor.gray
        self.view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(saveButton.snp.centerY)
            make.left.equalTo(saveButton.snp.right).offset(20)
            make.width.height.equalTo(30)
        }
    }
}

extension LivePhotoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livephotodetailCell", for: indexPath) as! LivePhotoDetailCollectionViewCell
        
        cell.updateLivePhotoData(livePhoto: dataSource[indexPath.row])
        return cell
        
    }
}
