//
//  TodayViewController.swift
//  extension
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit
import Appz
import NotificationCenter
import SnapKit
import SwiftyJSON
import AppLauncherKit


class TodayViewController: UICollectionViewController, NCWidgetProviding {

    let defaults = UserDefaults(suiteName: "group.com.lgtm.Launcher")
    var app: NSExtensionContext!

    lazy var flowLayout:UICollectionViewFlowLayout = {
        let v = UICollectionViewFlowLayout()
        v.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        return v
    }()

    var apps = [JSON]()

    func update() {
        defaults?.synchronize()
        if let restoredValue = defaults!.object(forKey: "apps") {
            apps = JSON(restoredValue).array!
            print("ok", apps, restoredValue)
        }
        else {
            print("Cannot find value")
        }

        let height = (self.collectionView?.collectionViewLayout.collectionViewContentSize.height)!

        collectionView!.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(height + 10)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.bounces = true
        collectionView!.alwaysBounceVertical = true
        collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.backgroundColor = nil

        collectionView!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }

        update()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "adc"), object: nil, queue: OperationQueue.main) { (_) -> Void in
            self.update()
            self.collectionView!.reloadData()
        }
        app = self.extensionContext
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let index = indexPath.row
        cell.iconButton.setTitle(apps[index]["title"].string, for: UIControlState())
        cell.iconButton.addTarget(self, action: #selector(TodayViewController.actions(_:)), for: UIControlEvents.touchUpInside)
        cell.titleLabel.text = apps[index]["title"].string

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        return CGSize(width: 50, height: 50)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        DispatchQueue.main.async(execute: {
            self.update()
            self.collectionView!.reloadData()
        })

        completionHandler(NCUpdateResult.newData)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func actions(_ sender: AnyObject) {

        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? CollectionViewCell {
                    if let indexPath = collectionView!.indexPath(for: cell) {
                        let type = apps[indexPath.row]["type"].string!
                        let action = apps[indexPath.row]["action"].string!
                        launchApp(type, action: action, extra: apps[indexPath.row]["extra"].string!, app: app)
                    }
                }
            }
        }
    }

}
