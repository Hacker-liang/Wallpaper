//
//  LivePhotoCategoryViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import SnapKit

protocol LivePhotoCategoryViewControllerDelegate: class {
    
    func didSelectedCagetory(category: LivePhotoCategory, subCagetoryId: Int, subCagetoryName: String)
    
    func didSelectedFindNewCagetory()
    
    func didSelectedFindHotCagetory()
    
    func didSelectedFindLikeCagetory()
    
}

class LivePhotoCategoryViewController: UIViewController {
    
    public weak var delegate: LivePhotoCategoryViewControllerDelegate?
    
    private var collectionView: UICollectionView!
    
    private var bgLayer: CAGradientLayer!
    
    private var dataSource = [LivePhotoCategory]()
    
    private var livePhotoManager: LivePhotoHelper!
    
    private var currentSelectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livePhotoManager = LivePhotoHelper()
        setupContentView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupContentView() {
        
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor.rgba(0xdfcece, alpha: 0.9).cgColor,UIColor.rgba(0xedc884, alpha: 0.9).cgColor,UIColor.rgba(0xe4b092, alpha: 0.9).cgColor,UIColor.rgba(0x006d8d, alpha: 0.9).cgColor]
        bgLayer = layer
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.locations = [0, 0.4, 0.6, 1.0]
        
        self.view.layer.addSublayer(layer)
        
        let layout = UICollectionViewFlowLayout()
        
        
        layout.itemSize = CGSize(width: 90, height: 100)
        layout.headerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 45.0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "LivePhotoCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = self.view.bounds
    }
    
    private func loadData() {
        LivePhotoNetworkHelper.requseLivePhotoCagetory() { [weak self] list in
            guard let weakSelf = self else {
                return
            }
            if let l = list {
                weakSelf.dataSource.removeAll()
                
                weakSelf.dataSource.append(contentsOf: l)
                weakSelf.collectionView.reloadData()
            }
        }
    }
    
    @objc func upgradeButtonAction() {
        
    }
    
}

extension LivePhotoCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func updateSectionHeaderView(_ view: inout UICollectionReusableView, category: LivePhotoCategory?, section: Int) {
        view.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        if section == 0 {
            view.backgroundColor = .rgba(0xd9d9d9, alpha: 1)
            let imageView = UIImageView(frame: CGRect(x: 18, y: 20, width: 25, height: 16))
            imageView.image = UIImage(named: "icon_category_menu")
            view.addSubview(imageView)
            let label = UILabel(frame: CGRect(x: 54, y: 0, width: 250, height: view.bounds.size.height))
            label.textColor = .rgb(0x5A5A5A)
            label.font = UIFont.systemFont(ofSize: 18.0)
            label.text = "壁纸分类"
            view.addSubview(label)

        } else if let category = category {
            view.backgroundColor = .rgba(0xAC9E86, alpha: 0.8)
            let imageView = UIImageView(frame: CGRect(x: 12, y: 8, width: 29, height: 29))
            imageView.sd_setImage(with: URL(string: category.icon ?? ""), completed: nil)
            view.addSubview(imageView)
            let label = UILabel(frame: CGRect(x: 58, y: 0, width: 250, height: view.bounds.size.height))
            label.textColor = .rgb(0xF2F2F2)
            label.font = UIFont.systemFont(ofSize: 18.0)
            label.text = category.categoryName ?? ""
            view.addSubview(label)
            if category.isFree ?? false {
                let freeImageView = UIImageView(frame: CGRect(x: collectionView.bounds.width-63, y: 12, width: 52, height: 21))
                freeImageView.image = UIImage(named: "icon_category_free")
                view.addSubview(freeImageView)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: 57.5)
        }
        return CGSize(width: collectionView.bounds.size.width, height: 45.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        
        if indexPath.section == 0 {
            self.updateSectionHeaderView(&view, category: nil, section: indexPath.section)

        } else {
            self.updateSectionHeaderView(&view, category: dataSource[indexPath.section-1], section: indexPath.section)

        }

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return dataSource[section-1].subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var retCell: LivePhotoCategoryCollectionViewCell!
        if indexPath.section == 0 {
            var icon = ""
            var title = ""
            if indexPath.row == 0 {
                title = "发现最新"
                icon = "icon_category_new"
            } else if indexPath.row == 1 {
                title = "热门影集"
                icon = "icon_category_hot"
            } else  if indexPath.row == 2 {
                title = "收藏影集"
                icon = "icon_category_like"
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LivePhotoCategoryCollectionViewCell
            cell.imageView.image = UIImage(named: icon)
            cell.titleLabel.text = title
            
            retCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LivePhotoCategoryCollectionViewCell
            let category = dataSource[indexPath.section-1]
            cell.imageView.sd_setImage(with: URL(string: category.subCategories[indexPath.row].icon ?? ""), completed: nil)
            cell.titleLabel.text = category.subCategories[indexPath.row].subCategoryName
            retCell = cell
        }
        
        retCell.titleLabel.textColor = currentSelectedIndex.section == indexPath.section && currentSelectedIndex.row == indexPath.row ? .white : .rgb(0x595959)
//        retCell.selectedImageView.isHidden = !(currentSelectedIndex.section == indexPath.section && currentSelectedIndex.row == indexPath.row)
        return retCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.delegate?.didSelectedFindNewCagetory()
            } else if indexPath.row == 1 {
                self.delegate?.didSelectedFindHotCagetory()
            } else if indexPath.row == 2 {
                self.delegate?.didSelectedFindLikeCagetory()
            }
        } else {
            let category = dataSource[indexPath.section-1]
            self.delegate?.didSelectedCagetory(category: category, subCagetoryId: category.subCategories[indexPath.row].subCategoryId, subCagetoryName: category.subCategories[indexPath.row].subCategoryName)
        }
        self.collectionView.reloadData()
    }
}
