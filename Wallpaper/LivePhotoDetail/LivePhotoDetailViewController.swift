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
import SDWebImage

class LivePhotoDetailViewController: UIViewController {
    
    var livePhotoManager: LivePhotoHelper!
    
    var buttonsBackgroundView: UIImageView!
    var saveButton: UIButton!
    var favoriteButton: UIButton!
    var moreButton: UIButton!
    var settingButton: UIButton!

    var detailCollectionView: UICollectionView!
    var albumCollectionView: UICollectionView!
    
    var rewardAdFinishCallback: ((_ isFinish: Bool)->Void)?
    var fullScreenAdFinishCallback: ((_ isFinish: Bool)->Void)?

    var photoSaveAdViewController: LivePhotoSaveAdViewController?
    
    var vipBannerView: LPUpgradeBannerView!
    
    var alreadyViewCount = 0
    
    var currentBannerAdView: BUNativeExpressBannerView?
    var currentFullScreenAd: BUNativeExpressFullscreenVideoAd?
    var currentRewardAd: BUNativeExpressRewardedVideoAd?

    var categoryIsFree: Bool = false
    
    var currentCellIndex: IndexPath = IndexPath(row: -1, section: 0)
    
    var dataSource = [LivePhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupContentView()
        self.updateDataSourceWithNewLivePhotos()
        loadBannerAdIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(vipStatusDidChange), name: NSNotification.Name(kVipStatusChangedNoti), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContentViewVisiable()
    }
    
    @objc func vipStatusDidChange() {
        self.updateContentViewVisiable()
    }
    
    public func updateDataSourcSelectedCategory(category: LivePhotoCategory, subCagetoryId: Int, subCagetoryName: String, selectedIndex: Int? = nil) {
        
//        let name = category.subCategories[subCategoryIndex].subCategoryName
        self.categoryIsFree = category.isFree ?? false
        LivePhotoNetworkHelper.requestLivePhotoList(in: subCagetoryId) { [weak self] (livePhotos) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dataSource.removeAll()
            if let p = livePhotos {
                weakSelf.dataSource.append(contentsOf: p)
            }
            
            weakSelf.detailCollectionView.reloadData()
            weakSelf.albumCollectionView.reloadData()
            if let index = selectedIndex, index >= 0, index < weakSelf.dataSource.count {
                self?.changePageIndex(index: index)
            } else {
                self?.changePageIndex(index: 0)
            }

        }
    }
    
    public func updateDataSourceWithHotLivePhotos() {
        
        categoryIsFree = false
        LivePhotoNetworkHelper.requestHotLivePhotoList() { (livePhotos) in

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
        
        categoryIsFree = false
        LivePhotoNetworkHelper.requestLatestLivePhotoList() { (livePhotos) in

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
        self.dataSource.removeAll()
        let p = LivePhotoHelper.requestUserLiveLivePhotos()
        self.dataSource.append(contentsOf: p)
        self.detailCollectionView.reloadData()
        self.albumCollectionView.reloadData()
        self.pageDidChanged()
    }
    
    
    public func showDetail() {
        self.buttonsBackgroundView.isHidden = false
        self.albumCollectionView.isHidden = false

        if LPAccount.shared.isVip {
            self.currentBannerAdView?.isHidden = true
            self.vipBannerView.isHidden = true
        } else {
            self.currentBannerAdView?.isHidden = false
            self.vipBannerView.isHidden = false
        }
        
    }
       
    public func hideDetail() {
        
        self.buttonsBackgroundView.isHidden = true
        self.currentBannerAdView?.isHidden = true
        self.albumCollectionView.isHidden = true
        self.vipBannerView.isHidden = true
    }
    
    private func loadBannerAdIfNeeded() {
        currentBannerAdView = AdManager.loadBannerAd(in: self)
        self.view.addSubview(currentBannerAdView!)
    }
    
    private func loadFullVideoAdIfNeeded(finishCallback: ((_ isFinish: Bool)->Void)?) {
        if LPAccount.shared.isVip {
            return
        }
        self.fullScreenAdFinishCallback = finishCallback
        currentFullScreenAd = AdManager.loadFullVideoAd(in: self)
    }
    
    private func loadRewardVideoAdIfNeeded(finishCallback: ((_ isFinish: Bool)->Void)?) {
        if LPAccount.shared.isVip {
            return
        }
        self.rewardAdFinishCallback = finishCallback
        currentRewardAd = AdManager.loadRewardAd(in: self)
    }
    
    private func forceWatchAdBeforDownload(model: LivePhotoModel) -> Bool {
        return model.forceAdWhenDownload && !LPAccount.shared.isVip
    }
    
    private func updateContentViewVisiable() {
        if LPAccount.shared.isVip {
            self.vipBannerView.isHidden = true
            self.currentBannerAdView?.isHidden = true
            
        } else {
            self.vipBannerView.isHidden = false
            self.currentBannerAdView?.isHidden = false
        }
        
        vipBannerView?.snp.updateConstraints({ (make) in
            if LPAccount.shared.isVip {
                make.height.equalTo(0)
            } else {
                make.height.equalTo(IS_IPHONE_X ? 75 : 54.5)
            }
        })
    }
    
    public func changePageIndex(index: Int) {
        guard index>=0 && index<self.dataSource.count else {
            return
        }
        self.detailCollectionView.scrollToItem(at:IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        self.albumCollectionView.scrollToItem(at:IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        self.pageDidChanged()
    }
    
    
    private func pageDidChanged() {
        let contentOffset = detailCollectionView.contentOffset
        let index = Int((contentOffset.x+100)/detailCollectionView.bounds.size.width)
        print("当前是第:\(index)页")
        alreadyViewCount += 1
        
        print("alreadyViewCount: \(alreadyViewCount)")
        
        if currentCellIndex.row != index {
            if currentCellIndex.row >= 0 && currentCellIndex.row < dataSource.count {
                (detailCollectionView.cellForItem(at: currentCellIndex) as? LivePhotoDetailCollectionViewCell)?.livePhotoView.stopPlayback()
                self.cancelDownloadIfNeeded(model: dataSource[currentCellIndex.row])
            }
            currentCellIndex = IndexPath(row: index, section: 0)
            if currentCellIndex.row >= 0 && currentCellIndex.row < dataSource.count {
                (detailCollectionView.cellForItem(at: currentCellIndex) as? LivePhotoDetailCollectionViewCell)?.livePhotoView.startPlayback(with: .full)

                self.startDownloadIfNeeded(model: dataSource[currentCellIndex.row])
            }
        }
        
        if currentCellIndex.row < dataSource.count {
            let model = self.dataSource[currentCellIndex.row]
            self.favoriteButton.isSelected = LivePhotoHelper.isUserLike(model)
        }
        reloadAlbumCollection()
        
        if alreadyViewCount >=  (arc4random() % 5 + 10) {
            alreadyViewCount = 0
            self.loadFullVideoAdIfNeeded(finishCallback: nil)
        }
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
                self.view.showLoading()
                LivePhotoDownloader.shared.downloadLivePhoto(livePhotoName: name, progressChange: { (progress) in
                    
                }) { [weak self] (success) in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.view.hideLoading()

                    weakSelf.detailCollectionView.reloadItems(at: [weakSelf.currentCellIndex])
                    (weakSelf.detailCollectionView.cellForItem(at: weakSelf.currentCellIndex) as? LivePhotoDetailCollectionViewCell)?.livePhotoView.startPlayback(with: .full)
                }
            }
        } else if let name = model.imageName {
            LivePhotoDownloader.shared.cancelDownloadFile(fileName: name)
            if !LPLivePhotoSourceManager.staticImageIsExitInSandbox(with: name) {
                self.view.showLoading()
                
                LivePhotoDownloader.shared.downloadStaticImage(imageName: name, progressChange: { (progress) in
                    
                }) { [weak self] (success, savedPath)  in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.view.hideLoading()
                    weakSelf.detailCollectionView.reloadItems(at: [weakSelf.currentCellIndex])
                }
            }
        }
    }
    
    @objc private func favoriteButtonAction(sender: UIButton) {
        guard currentCellIndex.row >= 0 && currentCellIndex.row < self.dataSource.count else {
            return
        }
        let model = self.dataSource[currentCellIndex.row]
        if sender.isSelected {
            LivePhotoHelper.cancelLikeLivePhoto(model)
        } else {
            LivePhotoHelper.likeLivePhoto(model)
        }
        sender.isSelected = !sender.isSelected
    }
    
    func saveLivePhoto(livePhoto: LivePhotoModel) {
        if livePhoto.isLivePhoto {
            if let name = livePhoto.movName {
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCreationRequest.forAsset()
                    let savedPath = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                    
                    if livePhoto.isLivePhoto {
                        request.addResource(with: .photo, fileURL: URL(fileURLWithPath: savedPath.jpgSavedPath), options: nil)
                        request.addResource(with: .pairedVideo, fileURL: URL(fileURLWithPath: savedPath.movSavedPath), options: nil)
                    } else {
                        request.addResource(with: .photo, fileURL: URL(fileURLWithPath: savedPath.jpgSavedPath), options: nil)
                    }
                    
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
            if let imageName = livePhoto.imageName, let data = try? Data(contentsOf: URL(fileURLWithPath: LPLivePhotoSourceManager.staticSavedPath(with: imageName))), let image = UIImage(data: data) {
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
    
    @objc private func saveLivePhotoAction(sender: UIButton) {
        guard let index = detailCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        let model = dataSource[index.row]

        if LPAccount.shared.isVip || !self.forceWatchAdBeforDownload(model: model) {
            self.saveLivePhoto(livePhoto: model)

        } else {
            let ctl = LivePhotoSaveAdViewController()
            ctl.willMove(toParent: self)
            self.addChild(ctl)
            self.view.addSubview(ctl.view)
            ctl.view.frame = self.view.bounds
            photoSaveAdViewController = ctl
            ctl.dismissButton.addTarget(self, action: #selector(saveAdCtlDismissAction), for: .touchUpInside)
            ctl.upgradeButton.addTarget(self, action: #selector(saveAdCtlUpgradeAction), for: .touchUpInside)
            ctl.watchAdButton.addTarget(self, action: #selector(saveAdCtlWatchAdAction), for: .touchUpInside)

        }
    }
    
    @objc func saveAdCtlDismissAction() {
        photoSaveAdViewController?.willMove(toParent: nil)
        photoSaveAdViewController?.removeFromParent()
        photoSaveAdViewController?.view.removeFromSuperview()
    }
    
    @objc func saveAdCtlUpgradeAction() {
        self.saveAdCtlDismissAction()
        self.purchaseVip()
    }
    
    @objc func saveAdCtlWatchAdAction() {
        self.saveAdCtlDismissAction()
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view, animated: true)
        self.loadRewardVideoAdIfNeeded { [weak self] (finish)  in
            hud.dismiss()
            if finish {
                if let index = self?.detailCollectionView.indexPathsForVisibleItems.first {
                    if let model = self?.dataSource[index.row] {
                        self?.saveLivePhoto(livePhoto: model)
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

//        self.view.addSubview(listCollectionView)
//        listCollectionView.snp.makeConstraints { (make) in
//            make.leading.equalTo(0.5)
//            make.trailing.equalTo(-0.5)
//            if IS_IPHONE_X {
//                make.bottom.equalTo(-20)
//            } else {
//                make.bottom.equalTo(-0.5)
//            }
//            make.height.equalTo(82)
//        }
        albumCollectionView = listCollectionView
        
        vipBannerView = LPUpgradeBannerView()
        vipBannerView.upgradeButton.addTarget(self, action: #selector(purchaseVip), for: .touchUpInside)
        self.view.addSubview(vipBannerView)
        vipBannerView?.snp.makeConstraints({ (make) in
            make.leading.trailing.bottom.equalTo(0)
            if LPAccount.shared.isVip {
                make.height.equalTo(0)
            } else {
                make.height.equalTo(IS_IPHONE_X ? 75 : 54.5)
            }
        })
        
        buttonsBackgroundView = UIImageView()
        buttonsBackgroundView.isUserInteractionEnabled = true
        buttonsBackgroundView.image = UIImage(named: "icon_detail_buttons_bg")
        self.view.addSubview(buttonsBackgroundView)
        buttonsBackgroundView.snp.makeConstraints { (make) in
            make.width.equalTo(343)
            make.height.equalTo(67.5)
            make.bottom.equalTo(vipBannerView.snp.top).offset(-22.5)
            make.centerX.equalToSuperview()
        }
        
        moreButton = UIButton(frame: .zero)
        moreButton.setImage(UIImage(named: "icon_detail_menu"), for: .normal)
        buttonsBackgroundView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.leading.equalTo(22.0)
            make.top.equalTo(3.0)
            make.width.height.equalTo(62)
        }
        
        saveButton = UIButton(frame: .zero)
        saveButton.setImage(UIImage(named: "icon_detail_save"), for: .normal)
        buttonsBackgroundView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.leading.equalTo(moreButton.snp.trailing).offset(18)
            make.top.equalTo(3.0)
            make.width.height.equalTo(62)
        }
        saveButton.addTarget(self, action: #selector(saveLivePhotoAction), for: .touchUpInside)
        
        
        favoriteButton = UIButton(frame: .zero)
        favoriteButton.setImage(UIImage(named: "icon_detail_like_normal"), for: .normal)
        favoriteButton.setImage(UIImage(named: "icon_detail_like_selected"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        buttonsBackgroundView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (make) in
            make.leading.equalTo(saveButton.snp.trailing).offset(15)
            make.top.equalTo(3.0)
            make.width.height.equalTo(62)
        }
        
        settingButton = UIButton(frame: .zero)
        settingButton.setImage(UIImage(named: "icon_detail_setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        buttonsBackgroundView.addSubview(settingButton)
        settingButton.snp.makeConstraints { (make) in
            make.leading.equalTo(favoriteButton.snp.trailing).offset(13)
            make.top.equalTo(3.0)
            make.width.height.equalTo(62)
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
        if collectionView == self.detailCollectionView {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livephotodetailCell", for: indexPath) as! LivePhotoDetailCollectionViewCell
            cell.updateLivePhoto(livePhoto: nil)
            cell.updateStaticPhoto(staticImage: nil)
            
            let model = dataSource[indexPath.row]
            if model.isLivePhoto, let name = model.movName {  //动态壁纸
                if LPLivePhotoSourceManager.livePhotoIsExitInSandbox(with: name) {
                    let paths = LPLivePhotoSourceManager.livePhotoSavedPath(with: name)
                    LivePhotoHelper.requestLivePhotoFromCache(jpgPath: paths.jpgSavedPath, movPath: paths.movSavedPath, targetSize: CGSize(width: cell.bounds.size.width*UIScreen.main.scale, height: cell.bounds.size.height*UIScreen.main.scale), callback: { (photo) in
                        if let p = photo {
                            cell.updateLivePhoto(livePhoto: p)
                        }
                    })
                } else {
                    if let imageUrl = model.coverImageUrl {
                        SDWebImageDownloader.shared.downloadImage(with:  URL(string: imageUrl)) { (image, data, error, success) in
                            if let i = image {
                                cell.updateStaticPhoto(staticImage: i)
                            }
                        }
                    }
                }
            } else {
                cell.updateLivePhoto(livePhoto: nil)
                if let name = model.imageName, LPLivePhotoSourceManager.staticImageIsExitInSandbox(with: name) {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: LPLivePhotoSourceManager.staticSavedPath(with: name))), let image = UIImage(data: data) {
                        cell.updateStaticPhoto(staticImage: image)
                    }
                } else {
                    if let imageUrl = model.coverImageUrl {
                        SDWebImageDownloader.shared.downloadImage(with:  URL(string: imageUrl)) { (image, data, error, success) in
                            if let i = image {
                                cell.updateStaticPhoto(staticImage: i)
                            }
                        }
                    }
                }
                
            }
            cell.payImageView.isHidden = !self.forceWatchAdBeforDownload(model: model)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livephotoAlbumCell", for: indexPath) as! LivePhotoAlubmCollectionViewCell
            cell.selectedImageView.isHidden = indexPath.row != currentCellIndex.row
            let model = dataSource[indexPath.row]
            if let imageUrl = model.coverImageUrl {
                cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, completed: nil)
            }
            return cell
        }
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
        print("nativeExpressFullscreenVideoAd didFailWithError\(String(describing: error))")
    }
    
    func nativeExpressFullscreenVideoAdDidPlayFinish(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        
    }
    
    func nativeExpressFullscreenVideoAdDidClose(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        
    }
}

extension LivePhotoDetailViewController: BUNativeExpressRewardedVideoAdDelegate {
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        rewardedVideoAd.show(fromRootViewController: self)
    }
    
    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        rewardAdFinishCallback?(true)
        rewardAdFinishCallback = nil
    }
    
}



