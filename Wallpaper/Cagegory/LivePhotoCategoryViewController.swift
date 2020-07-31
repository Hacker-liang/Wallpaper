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
    
}

class LivePhotoCategoryViewController: UIViewController {
    
    public weak var delegate: LivePhotoCategoryViewControllerDelegate?
    
    private var tableView: UITableView!
    
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
        self.updateContent()
    }
    
    private func setupContentView() {
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(UINib(nibName: "LivePhotoCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "LivePhotoCategoryTableViewCell")
        tableView.separatorColor = .rgba(0xB0B0B0, alpha: 0.15)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateContent() {
        if !LPAccount.shared.isVip {
            let header = LPUpgradeBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 99))
            header.upgradeButton.addTarget(self, action: #selector(upgradeButtonAction), for: .touchUpInside)
            tableView.tableHeaderView = header
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    private func loadData() {
        LivePhotoNetworkHelper.requseLivePhotoCagetory() { [weak self] list in
            guard let weakSelf = self else {
                return
            }
            if let l = list {
                weakSelf.dataSource.removeAll()
                weakSelf.dataSource.append(contentsOf: l)
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    @objc func upgradeButtonAction() {
        
    }
    
}

extension LivePhotoCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func createSectionHeaderView(category: LivePhotoCategory) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        view.backgroundColor = .rgb(0x2F2F2F)
        let imageView = UIImageView(frame: CGRect(x: 12, y: 5, width: 29, height: 29))
        imageView.sd_setImage(with: URL(string: category.icon ?? ""), completed: nil)
        view.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 58, y: 10, width: 250, height: 20))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.text = category.categoryName ?? ""
        view.addSubview(label)
        if category.isFree ?? false {
            let freeImageView = UIImageView(frame: CGRect(x: tableView.bounds.width-63, y: 9, width: 52, height: 21))
            freeImageView.image = UIImage(named: "icon_category_free")
            view.addSubview(freeImageView)
        }
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 5))
            view.backgroundColor = .black
            return view
        }
        return self.createSectionHeaderView(category: dataSource[section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].subCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 39.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var retCell: LivePhotoCategoryTableViewCell!
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LivePhotoCategoryTableViewCell", for: indexPath) as! LivePhotoCategoryTableViewCell
            cell.categoryImageView.image = UIImage(named: icon)
            cell.categoryLabel.text = title
            
            retCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LivePhotoCategoryTableViewCell", for: indexPath) as! LivePhotoCategoryTableViewCell
            cell.categoryImageView.sd_setImage(with: URL(string: dataSource[indexPath.section].subCategories[indexPath.row].icon ?? ""), completed: nil)
            cell.categoryLabel.text = dataSource[indexPath.section].subCategories[indexPath.row].subCategoryName
            retCell = cell
        }
        
        retCell.categoryLabel.textColor = currentSelectedIndex.section == indexPath.section && currentSelectedIndex.row == indexPath.row ? .white : .rgb(0x595959)
        retCell.selectedImageView.isHidden = !(currentSelectedIndex.section == indexPath.section && currentSelectedIndex.row == indexPath.row)
        return retCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath
        self.tableView.reloadData()
    }
}
