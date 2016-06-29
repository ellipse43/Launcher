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
        v.borderStyle = UITextBorderStyle.Line
        v.textAlignment = NSTextAlignment.Center
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).CGColor
        v.layer.borderWidth = 1.0
        return v
    }()

    lazy var titleTextField: UITextField = {
        let v = UITextField()
        v.borderStyle = UITextBorderStyle.Line
        v.textAlignment = NSTextAlignment.Center
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).CGColor
        v.layer.borderWidth = 1.0
        if let name = self.item["verbose_name"].string {
            v.text = name
        }
        return v
    }()

    lazy var saveButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(UIColor.blackColor(), forState: .Normal)
        v.setTitleColor(UIColor(rgb: 0x3aaf85), forState: .Highlighted)
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.setTitle("保存", forState: .Normal)
        v.addTarget(self, action: #selector(AddViewController.saveAction(_:)), forControlEvents: .TouchUpInside)

        v.setTitleColor(UIColor.blackColor(), forState: .Normal)
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).CGColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        for v in [iconImageView, attributeTextField, titleTextField, saveButton] {
            view.addSubview(v)
        }

        if let placeholder = item["placeholder"].string {
            attributeTextField.placeholder = placeholder
        } else {
            attributeTextField.hidden = true
        }

        view.backgroundColor = UIColor.whiteColor()

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
            if attributeTextField.hidden == true {
                make.top.equalTo(titleTextField.snp_bottom).offset(gap)
            } else {
                make.top.equalTo(attributeTextField.snp_bottom).offset(gap)
            }
            make.centerX.equalTo(view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }

    func saveAction(sender: UIButton) {

        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent("data.json")

            if NSFileManager.defaultManager().fileExistsAtPath(path) == false {
                do {
                    try JSON([]).rawString()!.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                }
                catch {/* error handling here */}
            }

            if let data = NSData(contentsOfFile: path) {
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
                    try JSON(origin).rawString()!.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                } catch {
                    print("write error")
                }
            }
        }
        // fix
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Index") as! UINavigationController
        self.presentViewController(viewController, animated: false, completion: nil)
    }

}
