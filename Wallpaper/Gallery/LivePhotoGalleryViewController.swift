//
//  LivePhotoGalleryViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/9/13.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoGalleryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource = [LivePhotoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: floor(self.view.bounds.size.width/3), height: floor(self.view.bounds.size.width/3/9*16))
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 0.0
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 0.0

        collectionView.register(UINib(nibName: "LivePhotoGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    public func updateDataSourcSelectedSubCategoryId(id: Int, catetoryName: String) {
        LivePhotoNetworkHelper.requestLivePhotoList(in: id) { [weak self] (livePhotos) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dataSource.removeAll()
            if let p = livePhotos {
                weakSelf.dataSource.append(contentsOf: p)
            }
            
            weakSelf.collectionView.reloadData()
        }
        self.titleLabel.text = catetoryName
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LivePhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LivePhotoGalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LivePhotoGalleryCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: dataSource[indexPath.row].coverImageUrl ?? ""), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
