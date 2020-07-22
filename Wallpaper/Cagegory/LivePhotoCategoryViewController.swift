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
    
    private var livePhotoManager: LivePhotoManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livePhotoManager = LivePhotoManager()
        setupContentView()
        loadData()
    }
    
    private func setupContentView() {
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
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
}

extension LivePhotoCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].subCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].categoryName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSource[indexPath.section].subCategories[indexPath.row].subCategoryName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
