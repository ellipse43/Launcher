//
//  IndexCollectionViewCell.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit

class IndexCollectionViewCell: UICollectionViewCell {

    lazy var iconButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(UIColor.black, for: UIControlState())
        v.setTitleColor(UIColor(rgb: 0x3aaf85), for: .highlighted)
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 6)
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        return v
    }()

    lazy var del: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "launch-close")
        v.isHidden = true
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
        contentView.addSubview(del)

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

        del.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(iconButton).offset(-5)
            make.left.equalTo(iconButton).offset(-5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        })

    }


}
