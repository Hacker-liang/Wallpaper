//
//  LPSegmentView.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

protocol LPSegmentViewDelegate: class {
    
    func didSelected(at index: Int)
}

class LPSegmentView: UIView {

    weak var delegate: LPSegmentViewDelegate?

    private var buttons = [UIButton]()
    private var titleLabels = [UILabel]()
    
    private var stackView: UIStackView!

    private var titles = [String]()
    private var normalImageNames = [String]()
    private var selectedImageNames = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(titles: [String], normalImageNames:[String], selectedImageNames:[String]) {
        self.init(frame: .zero)
        self.titles = titles
        self.normalImageNames = normalImageNames
        self.selectedImageNames = selectedImageNames
        setupContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateTitleFont(font: UIFont) {
        titleLabels.forEach { (label) in
            label.font = font
        }
    }
    
    public func markSelected(at index: Int) {
        guard index >= 0 && index < titleLabels.count else {
            return
        }
        titleLabels.forEach { (label) in
            label.textColor = (label == titleLabels[index] ? .white : .rgb(0x4E4E4E))
        }
        buttons.forEach { (button) in
            button.isSelected = (buttons[index]==button)
        }
    }
    
    @objc func itemSelectAction(tap: UIGestureRecognizer) {
        titleLabels.forEach { (label) in
            label.textColor = (label == titleLabels[tap.view?.tag ?? 0] ? .white : .rgb(0x4E4E4E))
        }
        buttons.forEach { (button) in
            button.isSelected = (button == buttons[tap.view?.tag ?? 0] ? true : false)
        }
        delegate?.didSelected(at: tap.view?.tag ?? 0)
    }
    
    private func setupContents() {
        
        stackView = UIStackView()
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        for (i,title) in titles.enumerated() {
            let itemView = UIView()
            itemView.tag = i
            
            let tap = UITapGestureRecognizer()
            tap.numberOfTouchesRequired = 1
            tap.numberOfTapsRequired = 1
            tap.addTarget(self, action: #selector(itemSelectAction))
            itemView.addGestureRecognizer(tap)
            
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.textColor = .rgb(0x4E4E4E)
            label.textAlignment = .center
            itemView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(-2)
                make.height.equalTo(18)
            }
            titleLabels.append(label)
            
            let button = UIButton()
            button.tag = i
            button.setImage(UIImage(named: normalImageNames[i]), for: .normal)
            button.setImage(UIImage(named: selectedImageNames[i]), for: .selected)
            button.isUserInteractionEnabled = false
            buttons.append(button)
            itemView.addSubview(button)
            
            button.snp.makeConstraints { (make) in
                make.leading.trailing.top.equalToSuperview()
                make.bottom.equalTo(label.snp.top)
            }
            
            stackView.addArrangedSubview(itemView)
        }
    }
}
