//
//  IndexViewController.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit
import AppLauncherKit
import SnapKit
import Appz
import SwiftyJSON
import UICollectionViewInteractiveMovement


class IndexViewController: UICollectionViewController {

    let app = UIApplication.sharedApplication()
    let defaults = NSUserDefaults(suiteName: "group.com.lgtm.Launcher")

    var apps = [JSON]() {
        didSet {
            defaults?.setObject(JSON(apps).object, forKey: "apps")
            defaults?.synchronize()

            NSNotificationCenter.defaultCenter().postNotificationName("adc", object: nil)
        }
    }

    lazy var indexCollectionView: UICollectionView = {
        let v = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        v.delegate = self
        v.dataSource = self
        v.bounces = true
        v.alwaysBounceVertical = true
        v.registerClass(IndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()

    lazy var flowLayout:UICollectionViewFlowLayout = {
        let v = UICollectionViewFlowLayout()
        v.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        return v
    }()

    lazy var addButton: UIButton = {
        let v = UIButton()
        v.setTitle("添加", forState: UIControlState.Normal)
        v.setTitleColor(UIColor.blackColor(), forState: .Normal)
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.addTarget(self, action: #selector(IndexViewController.addAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).CGColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IndexViewController.loadList(_:)), name:"load", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IndexViewController.enterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }

    func enterBackground() {
        endAnimation()
    }

    func _save() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent("data.json")

            do {
                try JSON(self.apps).rawString()!.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch {
                print("write error")
            }
        }
    }

    func loadApps() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent("data.json")

            if let data = NSData(contentsOfFile: path) {
                self.apps = JSON(data: data).arrayValue
            }
        }
    }

    func delApps(index: Int) {
        apps.removeAtIndex(index)
        _save()
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
    }

    func loadList(notification: NSNotification){
        loadApps()
        collectionView?.reloadData()
    }

    func setup() {
        if let navBar = self.navigationController?.navigationBar {
            navBar.topItem!.title = "启动器"
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            navBar.barTintColor = UIColor(rgb: 0x3aaf85)
        }

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.bounces = true
        collectionView!.alwaysBounceVertical = true
        collectionView!.registerClass(IndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()

        collectionView!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(10)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }

        view.addSubview(addButton)
        addButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-10)
            make.centerX.equalTo(view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        installsStandardGestureForInteractiveMovement = false
        installStandardGestureForShake()

        loadApps()
    }

    func installStandardGestureForShake() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(IndexViewController.longPressed(_:)))
        collectionView!.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! IndexCollectionViewCell
        let index = indexPath.row
        cell.iconButton.setTitle(apps[index]["title"].string, forState: .Normal)
        cell.iconButton.addTarget(self, action: #selector(IndexViewController.actions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.titleLabel.text = apps[index]["title"].string

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IndexViewController.delTapped(_:)))
        cell.del.userInteractionEnabled = true
        cell.del.addGestureRecognizer(tapGestureRecognizer)
        cell.del.hidden = true

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(50, 50)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let item = apps.removeAtIndex(sourceIndexPath.row)
        apps.insert(item, atIndex: destinationIndexPath.row)
    }

    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    func actions(sender: AnyObject) {

        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? IndexCollectionViewCell {
                    if let indexPath = collectionView!.indexPathForCell(cell) {
                        let type = apps[indexPath.row]["type"].string!
                        let action = apps[indexPath.row]["action"].string!
                        launchApp(type, action: action, extra: apps[indexPath.row]["extra"].string!, app: app)
                    }
                }
            }
        }
    }

    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = 0.12
        animation.autoreverses = true
        animation.repeatCount = HUGE
        animation.fromValue = NSValue(CATransform3D: CATransform3DMakeRotation(0.05, 0, 0, 1.0))
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(-0.05, 0, 0, 1.0))
        for cell in collectionView?.visibleCells() as! [IndexCollectionViewCell] {
            cell.layer.addAnimation(animation, forKey: "shakeMan")
            cell.del.hidden = false
            cell.iconButton.removeTarget(self, action: #selector(IndexViewController.actions(_:)), forControlEvents: .TouchUpInside)
        }
        installsStandardGestureForInteractiveMovement = true

        if navigationItem.rightBarButtonItem == nil {
            let barItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(IndexViewController.doneAction(_:)))
            navigationItem.rightBarButtonItem = barItem
        }

    }

    func endAnimation() {
        if navigationItem.rightBarButtonItem != nil {
            for cell in collectionView?.visibleCells() as! [IndexCollectionViewCell] {
                cell.layer.removeAnimationForKey("shakeMan")
                cell.del.hidden = true
                cell.iconButton.addTarget(self, action: #selector(IndexViewController.actions(_:)), forControlEvents: .TouchUpInside)
            }
            installsStandardGestureForInteractiveMovement = false
            navigationItem.rightBarButtonItem = nil
        }
    }

    func longPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            startAnimation()
        }
    }

    func delTapped(gesture: UITapGestureRecognizer) {

        if let v = gesture.view!.superview?.subviews[0] {
            if let superview = v.superview {
                if let cell = superview.superview as? IndexCollectionViewCell {
                    if let indexPath = collectionView!.indexPathForCell(cell) {
                        let row = indexPath.row
                        delApps(row)
                        if apps.count > 0 {
                            startAnimation()
                        }
                    }
                }
            }
        }
    }

    func doneAction(sender: UIButton) {
        endAnimation()
        _save()

    }

    func addAction(sender: UIButton) {

        endAnimation()

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let setting = UIAlertAction(title: "系统设置", style: .Default) { action -> Void in
            let items = JSON(
                [
                    [
                        "name": "设置",
                        "items": [
                            [
                                "type": "setting",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "打开设置"
                            ]
                        ]
                    ],
                    [
                        "name": "图片",
                        "items": [
                            [
                                "type": "gallery",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "图片"
                            ]
                        ]
                    ],
                    [
                        "name": "便签",
                        "items": [
                            [
                                "type": "note",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "便签"
                            ]
                        ]
                    ]
                ]
            )

            let vc = AppsViewController()
            vc.items = items

            self.navigationController!.pushViewController(vc, animated: true)
        }
        let application = UIAlertAction(title: "应用程序", style: .Default) { action -> Void in

            let weixin = [
                "name": "微信",
                "items": [
                    [
                        "type": "weixin",
                        "action": "open",
                        "name": "打开",
                        "verbose_name": "打开微信"
                    ],
                    [
                        "type": "weixin",
                        "action": "official_accounts",
                        "name": "公众号",
                        "verbose_name": "打开公众号"
                    ],
                    [
                        "type": "weixin",
                        "action": "moments",
                        "name": "朋友圈",
                        "verbose_name": "打开朋友圈"
                    ],
                    [
                        "type": "weixin",
                        "action": "profile",
                        "name": "个人信息",
                        "verbose_name": "个人信息"
                    ],
                    [
                        "type": "weixin",
                        "action": "scan",
                        "name": "扫一扫",
                        "verbose_name": "扫一扫"
                    ]
                ]
            ]

            let items = JSON(
                [
                    weixin,
                    [
                        "name": "网易云音乐",
                        "items": [
                            [
                                "type": "orpheus",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "网易云音乐"
                            ]
                        ]
                    ],
                    [
                        "name": "支付宝",
                        "items": [
                            [
                                "type": "alipay",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "支付宝"
                            ]
                        ]
                    ],
                    [
                        "name": "知乎",
                        "items": [
                            [
                                "type": "zhihu",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "知乎"
                            ]
                        ]
                    ],
                    [
                        "name": "Bilibili",
                        "items": [
                            [
                                "type": "bilibili",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "Bilibili"
                            ]
                        ]
                    ],
                    [
                        "name": "Uber",
                        "items": [
                            [
                                "type": "uber",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "Uber"
                            ]
                        ]
                    ],
                    [
                        "name": "滴滴出行",
                        "items": [
                            [
                                "type": "diditaxi",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "滴滴出行"
                            ]
                        ]
                    ],
                    [
                        "name": "多看阅读",
                        "items": [
                            [
                                "type": "duokan-reader",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "多看阅读"
                            ]
                        ]
                    ],
                    [
                        "name": "百度地图",
                        "items": [
                            [
                                "type": "baidumap",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "百度地图"
                            ]
                        ]
                    ],
                    [
                        "name": "微博",
                        "items": [
                            [
                                "type": "weibo",
                                "action": "open",
                                "name": "打开",
                                "verbose_name": "微博"
                            ]
                        ]
                    ]
                ]
            )

            let vc = AppsViewController()
            vc.items = items

            self.navigationController!.pushViewController(vc, animated: true)
        }
        let contact = UIAlertAction(title: "联系人", style: .Default) { action -> Void in

            let items = JSON(
                [
                    [
                        "name": "电话",
                        "items": [
                            [
                                "type": "phone",
                                "action": "dial",
                                "name": "拨号",
                                "verbose_name": "拨号",
                                "placeholder": "输入手机号"
                            ]
                        ]
                    ],
                    [
                        "name": "短信",
                        "items": [
                            [
                                "type": "message",
                                "action": "send",
                                "name": "发送",
                                "verbose_name": "发送短信",
                                "placeholder": "输入手机号"
                            ]
                        ]
                    ]
                ]
            )

            let vc = AppsViewController()
            vc.items = items

            self.navigationController!.pushViewController(vc, animated: true)
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in

        }

        for v in [setting, application, contact, cancel] {
            sheet.addAction(v)
        }

        presentViewController(sheet, animated: true, completion: nil)
    }

}
