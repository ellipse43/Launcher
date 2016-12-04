//
//  AddViewController.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddViewController: UIViewController {

    var item = JSON([:])

    lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor(rgb: 0x3aaf85)
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()

    lazy var attributeTextField: UITextField = {
        let v = UITextField()
        v.borderStyle = UITextBorderStyle.line
        v.textAlignment = NSTextAlignment.center
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).cgColor
        v.layer.borderWidth = 1.0
        return v
    }()

    lazy var titleTextField: UITextField = {
        let v = UITextField()
        v.borderStyle = UITextBorderStyle.line
        v.textAlignment = NSTextAlignment.center
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).cgColor
        v.layer.borderWidth = 1.0
        if let name = self.item["verbose_name"].string {
            v.text = name
        }
        return v
    }()

    lazy var saveButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(UIColor.black, for: UIControlState())
        v.setTitleColor(UIColor(rgb: 0x3aaf85), for: .highlighted)
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.setTitle("保存", for: UIControlState())
        v.addTarget(self, action: #selector(AddViewController.saveAction(_:)), for: .touchUpInside)

        v.setTitleColor(UIColor.black, for: UIControlState())
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        for v in [iconImageView, attributeTextField, titleTextField, saveButton] as [Any] {
            view.addSubview(v as! UIView)
        }

        if let placeholder = item["placeholder"].string {
            attributeTextField.placeholder = placeholder
        } else {
            attributeTextField.isHidden = true
        }

        view.backgroundColor = UIColor.white

        let gap = 20

        iconImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(80)
            make.centerX.equalTo(view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        titleTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconImageView.snp_bottom).offset(gap)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }

        attributeTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleTextField.snp_bottom).offset(gap)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }

        saveButton.snp_makeConstraints { (make) -> Void in
            if attributeTextField.isHidden == true {
                make.top.equalTo(titleTextField.snp_bottom).offset(gap)
            } else {
                make.top.equalTo(attributeTextField.snp_bottom).offset(gap)
            }
            make.centerX.equalTo(view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }

    func saveAction(_ sender: UIButton) {

        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent("data.json")

            if FileManager.default.fileExists(atPath: path) == false {
                do {
                    try JSON([]).rawString()!.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {/* error handling here */}
            }

            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                var origin = JSON(data: data).arrayValue
                let newItem = [
                    "icon": "default",
                    "title": titleTextField.text!,
                    "type": item["type"].string!,
                    "action": item["action"].string!,
                    "extra": attributeTextField.text!
                ]
                origin.append(JSON(newItem))
                print(origin)

                do {
                    try JSON(origin).rawString()!.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                } catch {
                    print("write error")
                }
            }
        }
        // fix
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Index") as! UINavigationController
        self.present(viewController, animated: false, completion: nil)
    }

}
