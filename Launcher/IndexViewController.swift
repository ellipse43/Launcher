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


class IndexViewController: UICollectionViewController {

    let app = UIApplication.shared
    let defaults = UserDefaults(suiteName: "group.com.lgtm.Launcher")

    var apps = [JSON]() {
        didSet {
            defaults?.set(JSON(apps).object, forKey: "apps")
            defaults?.synchronize()

            NotificationCenter.default.post(name: Notification.Name(rawValue: "adc"), object: nil)
        }
    }

    lazy var indexCollectionView: UICollectionView = {
        let v = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        v.delegate = self
        v.dataSource = self
        v.bounces = true
        v.alwaysBounceVertical = true
        v.register(IndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.backgroundColor = UIColor.white
        return v
    }()

    lazy var flowLayout:UICollectionViewFlowLayout = {
        let v = UICollectionViewFlowLayout()
        v.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        return v
    }()

    lazy var addButton: UIButton = {
        let v = UIButton()
        v.setTitle("添加", for: UIControlState())
        v.setTitleColor(UIColor.black, for: UIControlState())
        v.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        v.addTarget(self, action: #selector(IndexViewController.addAction(_:)), for: UIControlEvents.touchUpInside)
        v.layer.borderColor = UIColor(rgb: 0x3aaf85).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 20
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(IndexViewController.loadList(_:)), name:NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IndexViewController.enterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    func enterBackground() {
        endAnimation()
    }

    func _save() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent("data.json")

            do {
                try JSON(self.apps).rawString()!.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print("write error")
            }
        }
    }

    func loadApps() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent("data.json")

            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                self.apps = JSON(data: data).arrayValue
            }
        }
    }

    func delApps(_ index: Int) {
        apps.remove(at: index)
        _save()
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
    }

    func loadList(_ notification: Notification){
        loadApps()
        collectionView?.reloadData()
    }

    func setup() {
        if let navBar = self.navigationController?.navigationBar {
            navBar.topItem!.title = "启动器"
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navBar.barTintColor = UIColor(rgb: 0x3aaf85)
        }

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.bounces = true
        collectionView!.alwaysBounceVertical = true
        collectionView!.register(IndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.white

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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IndexCollectionViewCell
        let index = indexPath.row
        cell.iconButton.setTitle(apps[index]["title"].string, for: UIControlState())
        cell.iconButton.addTarget(self, action: #selector(IndexViewController.actions(_:)), for: UIControlEvents.touchUpInside)
        cell.titleLabel.text = apps[index]["title"].string

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IndexViewController.delTapped(_:)))
        cell.del.isUserInteractionEnabled = true
        cell.del.addGestureRecognizer(tapGestureRecognizer)
        cell.del.isHidden = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        return CGSize(width: 50, height: 50)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let item = apps.remove(at: sourceIndexPath.row)
        apps.insert(item, at: destinationIndexPath.row)
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    func actions(_ sender: AnyObject) {

        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? IndexCollectionViewCell {
                    if let indexPath = collectionView!.indexPath(for: cell) {
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
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0.05, 0, 0, 1.0))
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(-0.05, 0, 0, 1.0))
        for cell in collectionView?.visibleCells as! [IndexCollectionViewCell] {
            cell.layer.add(animation, forKey: "shakeMan")
            cell.del.isHidden = false
            cell.iconButton.removeTarget(self, action: #selector(IndexViewController.actions(_:)), for: .touchUpInside)
        }
        installsStandardGestureForInteractiveMovement = true

        if navigationItem.rightBarButtonItem == nil {
            let barItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IndexViewController.doneAction(_:)))
            navigationItem.rightBarButtonItem = barItem
        }

    }

    func endAnimation() {
        if navigationItem.rightBarButtonItem != nil {
            for cell in collectionView?.visibleCells as! [IndexCollectionViewCell] {
                cell.layer.removeAnimation(forKey: "shakeMan")
                cell.del.isHidden = true
                cell.iconButton.addTarget(self, action: #selector(IndexViewController.actions(_:)), for: .touchUpInside)
            }
            installsStandardGestureForInteractiveMovement = false
            navigationItem.rightBarButtonItem = nil
        }
    }

    func longPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            startAnimation()
        }
    }

    func delTapped(_ gesture: UITapGestureRecognizer) {

        if let v = gesture.view!.superview?.subviews[0] {
            if let superview = v.superview {
                if let cell = superview.superview as? IndexCollectionViewCell {
                    if let indexPath = collectionView!.indexPath(for: cell) {
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

    func doneAction(_ sender: UIButton) {
        endAnimation()
        _save()

    }

    func addAction(_ sender: UIButton) {

        endAnimation()

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let setting = UIAlertAction(title: "系统设置", style: .default) { action -> Void in
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
        let application = UIAlertAction(title: "应用程序", style: .default) { action -> Void in

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
            ] as [String : Any]

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
        let contact = UIAlertAction(title: "联系人", style: .default) { action -> Void in

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
        let cancel = UIAlertAction(title: "取消", style: .cancel) { action -> Void in

        }

        for v in [setting, application, contact, cancel] {
            sheet.addAction(v)
        }

        present(sheet, animated: true, completion: nil)
    }

}
