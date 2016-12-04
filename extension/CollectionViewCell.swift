//
//  CollectionViewCell.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    lazy var iconButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(UIColor.white, for: UIControlState())
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 6)
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.white
        v.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        contentView.addSubview(iconButton)
        contentView.addSubview(titleLabel)

        iconButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }

        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconButton.snp_bottom).offset(5)
            make.centerX.equalTo(iconButton.snp_centerX)
        }
    }
}
