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
    
    public func markSelected(at index: Int) {
        guard index >= 0 && index < titleLabels.count else {
            return
        }
        titleLabels.forEach { (label) in
            label.textColor = (label == titleLabels[index] ? .white : .gray)
        }
        buttons.forEach { (button) in
            button.isSelected = (buttons[index]==button)
        }
    }
    
    @objc func itemButtonAction(sender: UIButton) {
        titleLabels.forEach { (label) in
            label.textColor = (label == titleLabels[sender.tag] ? .white : .gray)
        }
        buttons.forEach { (button) in
            button.isSelected = button==sender
        }
        delegate?.didSelected(at: sender.tag)
    }
    
    private func setupContents() {
        
        stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        for (i,title) in titles.enumerated() {
            let itemView = UIView()
            
            let label = UILabel()
            label.text = title
            label.textColor = .gray
            label.textAlignment = .center
            itemView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(20)
            }
            titleLabels.append(label)
            
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(itemButtonAction), for: .touchUpInside)
            button.setImage(UIImage(named: normalImageNames[i]), for: .normal)
            button.setImage(UIImage(named: selectedImageNames[i]), for: .selected)
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
