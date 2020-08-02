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
    
    var livePhotoManager: LivePhotoHelper!
    
    var saveButton: UIButton!
    var favoriteButton: UIButton!
    var moreButton: UIButton!
    var detailCollectionView: UICollectionView!
    var albumCollectionView: UICollectionView!
    
    var vipBannerView: LPUpgradeBannerView!
    
    var currentBannerAdView: BUNativeExpressBannerView?
    var currentFullScreenAd: BUNativeExpressFullscreenVideoAd?

    var currentCellIndex: IndexPath = IndexPath(row: -1, section: 0)
    
    var dataSource = [LivePhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupContentView()
        self.updateDataSourceWithNewLivePhotos()
        loadBannerAdIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContentViewVisiable()
    }
    
    public func updateDataSourcSelectedSubCategoryId(id: Int) {
        LivePhotoNetworkHelper.requestLivePhotoList(in: id) { [weak self] (livePhotos) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dataSource.removeAll()
            if let p = livePhotos {
                weakSelf.dataSource.append(contentsOf: p)
            }
            
            weakSelf.detailCollectionView.reloadData()
            weakSelf.albumCollectionView.reloadData()
            weakSelf.pageDidChanged()
        }
    }
    
    public func updateDataSourceWithHotLivePhotos() {
        var limit = 10
        if LPAccount.shared.isVip {
            limit = 1000
        }
        LivePhotoNetworkHelper.requestHotLivePhotoList(limit: limit) { (livePhotos) in

            self.dataSource.removeAll()
            if let p = livePhotos {
                self.dataSource.append(contentsOf: p)
            }
            
            self.detailCollectionView.reloadData()
            self.albumCollectionView.reloadData()
            self.pageDidChanged()
        }
        
    }
    
    public func updateDataSourceWithNewLivePhotos() {
        var limit = 10
        if LPAccount.shared.isVip {
            limit = 100
        }
        LivePhotoNetworkHelper.requestLatestLivePhotoList(limit: limit) { (livePhotos) in

            self.dataSource.removeAll()
            if let p = livePhotos {
                self.dataSource.append(contentsOf: p)
            }
            
            self.detailCollectionView.reloadData()
            self.albumCollectionView.reloadData()
            self.pageDidChanged()
        }
        
    }
    
    public func updateDataSourceWithFavoriteLivePhotos() {
        var limit = 10
        if LPAccount.shared.isVip {
            limit = 100
        }
        
        self.dataSource.removeAll()
        let p = LivePhotoHelper.requestUserLiveLivePhotos()
        self.dataSource.append(contentsOf: p)
        self.detailCollectionView.reloadData()
        self.albumCollectionView.reloadData()
        self.pageDidChanged()
    }
    
    
    public func showDetail() {
        self.saveButton.alpha = 1.0
        self.favoriteButton.alpha = 1.0
        self.moreButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(saveButton.snp.centerY)
        }
        if !LPAccount.shared.isVip {
            self.currentBannerAdView?.isHidden = false
            self.albumCollectionView.isHidden = false
            self.vipBannerView.isHidden = false
        } else {
            self.albumCollectionView.isHidden = false
        }
        
    }
       
    public func hideDetail() {
        self.saveButton.alpha = 0.0
        self.favoriteButton.alpha = 0.0
        self.moreButton.snp.updateConstraints { (make) in
            if IS_IPHONE_X {
                make.centerY.equalTo(saveButton.snp.centerY).offset(140)
            } else {
                make.centerY.equalTo(saveButton.snp.centerY).offset(120)
            }
        }
        self.currentBannerAdView?.isHidden = true
        self.albumCollectionView.isHidden = true
        self.vipBannerView.isHidden = true
    }
    
    private func loadBannerAdIfNeeded() {
        currentBannerAdView = AdManager.loadBannerAd(in: self)
        self.view.addSubview(currentBannerAdView!)
    }
    
    private func loadFullVideoAdIfNeeded() {
        currentFullScreenAd = AdManager.loadFullVideoAd(in: self)
    }
    
    private func updateContentViewVisiable() {
        if LPAccount.shared.isVip {
            self.vipBannerView.isHidden = true
            self.currentBannerAdView?.isHidden = true
            
        } else {
            
        }
    }
    
    private func pageDidChanged() {
        let contentOffset = detailCollectionView.contentOffset
        let index = Int((contentOffset.x+100)/detailCollectionView.bounds.size.width)
        print("当前是第:\(index)页")
        
        if currentCellIndex.row != index {
            if currentCellIndex.row >= 0 && currentCellIndex.row < dataSource.count {
                self.cancelDownloadIfNeeded(model: dataSource[currentCellIndex.row])
            }
            currentCellIndex = IndexPath(row: index, section: 0)
            if currentCellIndex.row >= 0 && currentCellIndex.row < dataSource.count {
                self.startDownloadIfNeeded(model: dataSource[currentCellIndex.row])
            }
        }
        
        if currentCellIndex.row < dataSource.count {
            let model = self.dataSource[currentCellIndex.row]
            if let name = model.imageName {
                self.favoriteButton.isSelected = LivePhotoHelper.isUserLike(model)
            }
            if model.isLivePhoto {
                (detailCollectionView.cellForItem(at: currentCellIndex) as? LivePhotoDetailCollectionViewCell)?.livePhotoView.startPlayback(with: .full)
            }
        }
        reloadAlbumCollection()
    }
    
    private func reloadAlbumCollection() {
        for cell in albumCollectionView.visibleCells  {
            if let index = albumCollectionView.indexPath(for: cell) {
                (cell as! LivePhotoAlubmCollectionViewCell).selectedImageView.isHidden = currentCellIndex.row != index.row
            }
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
                    weakSelf.detailCollectionView.reloadItems(at: [weakSelf.currentCellIndex])
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
                    weakSelf.detailCollectionView.reloadItems(at: [weakSelf.currentCellIndex])
                }
            }
        }
    }
    
    @objc private func favoriteButtonAction(sender: UIButton) {
        let model = self.dataSource[currentCellIndex.row]
        if sender.isSelected {
            LivePhotoHelper.cancelLikeLivePhoto(model)
        } else {
            LivePhotoHelper.likeLivePhoto(model)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func saveLivePhoto(sender: UIButton) {
        
        if let index = detailCollectionView.indexPathsForVisibleItems.first {
            let model = dataSource[index.row]
            if model.isLivePhoto {
                if let name = model.movName {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        let savedPath = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                        request.addResource(with: .photo, fileURL: URL(fileURLWithPath: savedPath.jpgSavedPath), options: nil)
                        request.addResource(with: .pairedVideo, fileURL: URL(fileURLWithPath: savedPath.movSavedPath), options: nil)
                        
                    }) { (success, error) in
                        DispatchQueue.main.async {
                            if error == nil {
                                self.view.makeToast("保存成功")
                                print("保存成功")
                            } else {
                                self.view.makeToast("保存失败")
                                print("保存失败：\(String(describing: error))")
                            }
                        }
                    }
                }
                
            } else {
                if let imageName = model.imageName, let data = try? Data(contentsOf: URL(fileURLWithPath: LPLivePhotoSourceManager.staticSavedPath(with: imageName))), let image = UIImage(data: data) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { (success, error) in
                        DispatchQueue.main.async {
                            if error == nil {
                                self.view.makeToast("保存成功")
                                print("保存成功")
                            } else {
                                self.view.makeToast("保存失败")
                                print("保存失败：\(String(describing: error))")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func purchaseVip() {
        let purchaseVC = LPUpgradeViewController()
        purchaseVC.modalPresentationStyle = .fullScreen
        self.present(purchaseVC, animated: true, completion: nil)
    }
    
    private func setupContentView() {
        
        let detail_layout = UICollectionViewFlowLayout()
        detail_layout.scrollDirection = .horizontal
        detail_layout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        detail_layout.minimumLineSpacing = 0.0
        detail_layout.minimumInteritemSpacing = 0.0
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: detail_layout)
        collectionView.register(UINib.init(nibName: "LivePhotoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "livephotodetailCell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        detailCollectionView = collectionView
        
        let list_layout = UICollectionViewFlowLayout()
        list_layout.scrollDirection = .horizontal
        list_layout.itemSize = CGSize(width: 46, height: 82)
        list_layout.minimumLineSpacing = 0.5
        list_layout.minimumInteritemSpacing = 0.5
        
        let listCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: list_layout)
        
        listCollectionView.register(UINib.init(nibName: "LivePhotoAlubmCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "livephotoAlbumCell")
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.backgroundColor = .clear
        listCollectionView.showsHorizontalScrollIndicator = false

        self.view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0.5)
            make.trailing.equalTo(-0.5)
            if IS_IPHONE_X {
                make.bottom.equalTo(-20)
            } else {
                make.bottom.equalTo(-0.5)
            }
            make.height.equalTo(82)
        }
        albumCollectionView = listCollectionView
        
        saveButton = UIButton(frame: .zero)
        saveButton.setImage(UIImage(named: "icon_detail_save"), for: .normal)
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
            make.bottom.equalTo(listCollectionView.snp.top).offset(-28.0)
        }
        saveButton.addTarget(self, action: #selector(saveLivePhoto), for: .touchUpInside)
        
        moreButton = UIButton(frame: .zero)
        moreButton.setImage(UIImage(named: "icon_detail_menu"), for: .normal)

        self.view.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.right.equalTo(saveButton.snp.left).offset(-20)
            make.width.height.equalTo(saveButton.snp.width)
            make.centerY.equalTo(saveButton.snp.centerY)
        }
        
        favoriteButton = UIButton(frame: .zero)
        favoriteButton.setImage(UIImage(named: "icon_detail_like_normal"), for: .normal)
        favoriteButton.setImage(UIImage(named: "icon_detail_like_selected"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        self.view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(saveButton.snp.centerY)
            make.left.equalTo(saveButton.snp.right).offset(20)
            make.width.height.equalTo(saveButton.snp.width)
        }
        
        vipBannerView = LPUpgradeBannerView()
        vipBannerView.upgradeButton.addTarget(self, action: #selector(purchaseVip), for: .touchUpInside)
        self.view.addSubview(vipBannerView)
        vipBannerView?.snp.makeConstraints({ (make) in
            make.leading.trailing.bottom.equalTo(0)
            if IS_IPHONE_X {
                make.height.equalTo(110)
            } else {
                make.height.equalTo(99)
            }
        })
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
        if collectionView == self.detailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livephotodetailCell", for: indexPath) as! LivePhotoDetailCollectionViewCell
            let model = dataSource[indexPath.row]
            if model.isLivePhoto, let name = model.movName {
                if LPLivePhotoSourceManager.livePhotoIsExitInSandbox(with: name) {
                    let paths = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                    LivePhotoHelper.requestLivePhotoFromCache(jpgPath: paths.jpgSavedPath, movPath: paths.movSavedPath, targetSize: CGSize(width: cell.bounds.size.width*UIScreen.main.scale, height: cell.bounds.size.height*UIScreen.main.scale), callback: { (photo) in
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livephotoAlbumCell", for: indexPath) as! LivePhotoAlubmCollectionViewCell
        cell.selectedImageView.isHidden = indexPath.row != currentCellIndex.row
        let model = dataSource[indexPath.row]
        if let imageUrl = model.coverImageUrl {
            cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == albumCollectionView {
            self.detailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                self.pageDidChanged()
            }
        }
    }
}

extension LivePhotoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageDidChanged()
    }
}

extension LivePhotoDetailViewController: BUNativeExpressBannerViewDelegate {
    
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        print("广告加载成功")
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        print("广告加载失败: \(String(describing: error))")
    }
    
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
        print("nativeExpressBannerAdViewRenderSuccess")
    }
    
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        print("nativeExpressBannerAdViewWillBecomVisible")
    }
    
    func nativeExpressBannerAdViewDidCloseOtherController(_ bannerAdView: BUNativeExpressBannerView, interactionType: BUInteractionType) {
        print("nativeExpressBannerAdViewDidCloseOtherController")
    }
    
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        print("nativeExpressBannerAdViewDidClick")
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        print("nativeExpressBannerAdView dislikeWithReason:\(String(describing: filterwords?.map{return $0.name}))")
    }
}

extension LivePhotoDetailViewController: BUNativeExpressFullscreenVideoAdDelegate {
    func nativeExpressFullscreenVideoAdDidLoad(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        print("nativeExpressFullscreenVideoAdDidLoad")
        fullscreenVideoAd.show(fromRootViewController: self)
    }
    
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        print("nativeExpressBannerAdViewRenderFail")
    }
    
    func nativeExpressFullscreenVideoAd(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        print("nativeExpressFullscreenVideoAd didFailWithError\(error)")
    }
}

extension LivePhotoDetailViewController: LivePhotoCategoryViewControllerDelegate {
    
    func didSelectedFindLikeCagetory() {
        self.updateDataSourceWithFavoriteLivePhotos()
    }
    
    func didSelectedFindNewCagetory() {
        self.updateDataSourceWithNewLivePhotos()
    }
    
    func didSelectedFindHotCagetory() {
        self.updateDataSourceWithHotLivePhotos()
    }
    
    func didSelectedCagetory(category: LivePhotoCategory, subCagetoryId: Int, subCagetoryName: String) {
        self.updateDataSourcSelectedSubCategoryId(id: subCagetoryId)
    }
}
