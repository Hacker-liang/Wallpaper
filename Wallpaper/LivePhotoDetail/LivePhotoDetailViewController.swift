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
import JGProgressHUD

class LivePhotoDetailViewController: UIViewController {
    
    var selectedSubCategoryId: Int?
    
    var livePhotoManager: LivePhotoHelper!
    
    var livePhotoView: PHLivePhotoView!
    var saveButton: UIButton!
    var favoriteButton: UIButton!
    var moreButton: UIButton!
    var collectionView: UICollectionView!
    
    var currentCellIndex: IndexPath = IndexPath(row: -1, section: 0)

    var pageIndex = 0
    
    var dataSource = [LivePhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                guard let weakSelf = self else {
                    return
                }
                self?.dataSource.append(contentsOf: list)
                
                self?.pageIndex += 1
                self?.collectionView.reloadData()
                if weakSelf.pageIndex == 1 {
                    self?.pageDidChanged()
                }
            }
        }
    }
    
    private func pageDidChanged() {
        let contentOffset = collectionView.contentOffset
        let index = Int((contentOffset.x+100)/collectionView.bounds.size.width)
        print("当前是第:\(index)页")
        if currentCellIndex.row != index {
            if currentCellIndex.row >= 0 {
                self.cancelDownloadIfNeeded(model: dataSource[currentCellIndex.row])
            }
            currentCellIndex = IndexPath(row: index, section: 0)
            self.startDownloadIfNeeded(model: dataSource[currentCellIndex.row])
        }
    }
    
    private func cancelDownloadIfNeeded(model: LivePhotoModel) {

        JGProgressHUD.allProgressHUDs(in: self.view).forEach { (hud) in
            hud.dismiss()
        }
        if model.isLivePhoto, let name = model.movName {
            LivePhotoDownloader.shared.cancelDownloadLivePhoto(livePhotoName: name)
        } else if let name = model.imageName {
            LivePhotoDownloader.shared.cancelDownloadLivePhoto(livePhotoName: name)
        }
    }
    
    private func startDownloadIfNeeded(model: LivePhotoModel) {
        if model.isLivePhoto, let name = model.movName {
            if !LPLivePhotoSourceManager.livePhotoIsExitInSandbox(with: name) {
                let hud = JGProgressHUD(style: .dark)
                hud.show(in: self.view)
                
                LivePhotoDownloader.shared.downloadLivePhoto(livePhotoName: name, progressChange: { (progress) in
                    
                }) { [weak self] (success) in
                    hud.dismiss()
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.collectionView.reloadItems(at: [weakSelf.currentCellIndex])
                }
            }
        } else if let name = model.imageName {
            LivePhotoDownloader.shared.cancelDownloadFile(fileName: name)
            if !LPLivePhotoSourceManager.staticImageIsExitInSandbox(with: name) {
                let hud = JGProgressHUD(style: .dark)
                hud.show(in: self.view)
                
                LivePhotoDownloader.shared.downloadStaticImage(imageName: name, progressChange: { (progress) in
                    
                }) { [weak self] (success, savedPath)  in
                    hud.dismiss()
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.collectionView.reloadItems(at: [weakSelf.currentCellIndex])
                }
            }
        }
    }
    
    @objc private func saveLivePhoto(sender: UIButton) {
        
        if let index = collectionView.indexPathsForVisibleItems.first {
            let model = dataSource[index.row]
            if model.isLivePhoto {
                if let name = model.movName {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        let savedPath = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                        request.addResource(with: .photo, fileURL: URL(fileURLWithPath: savedPath.jpgSavedPath), options: nil)
                        request.addResource(with: .pairedVideo, fileURL: URL(fileURLWithPath: savedPath.movSavedPath), options: nil)
                        
                    }) { (success, error) in
                        if error == nil {
                            print("保存成功")
                        } else {
                            print("保存失败：\(String(describing: error))")
                        }
                    }
                }
                
            } else {
                if let imageName = model.imageName, let data = try? Data(contentsOf: URL(fileURLWithPath: LPLivePhotoSourceManager.staticSavedPath(with: imageName))), let image = UIImage(data: data) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { (success, error) in
                        if error == nil {
                            print("保存成功")
                        } else {
                            print("保存失败：\(String(describing: error))")
                        }
                    }
                }
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
        
        saveButton.addTarget(self, action: #selector(saveLivePhoto), for: .touchUpInside)
        
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
        let model = dataSource[indexPath.row]
        if model.isLivePhoto, let name = model.movName {
            if LPLivePhotoSourceManager.livePhotoIsExitInSandbox(with: name) {
                let paths = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                LivePhotoHelper.requestLivePhotoFromCache(jpgPath: paths.jpgSavedPath, movPath: paths.movSavedPath, targetSize: cell.bounds.size, callback: { (photo) in
                    if let p = photo {
                        cell.updateLivePhoto(livePhoto: p)
                    }
                })
            }
        } else if let name = model.imageName, LPLivePhotoSourceManager.staticImageIsExitInSandbox(with: name) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: LPLivePhotoSourceManager.staticSavedPath(with: name))), let image = UIImage(data: data) {
                cell.updateStaticPhoto(staticImage: image)
            }
        } else {
            cell.updateLivePhoto(livePhoto: nil)
            cell.updateStaticPhoto(staticImage: nil)
        }
        return cell
    }
}

extension LivePhotoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageDidChanged()
    }

}
