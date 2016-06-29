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

    let defaults = NSUserDefaults(suiteName: "group.com.lgtm.Launcher")
    var app: NSExtensionContext!

    lazy var flowLayout:UICollectionViewFlowLayout = {
        let v = UICollectionViewFlowLayout()
        v.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        return v
    }()

    var apps = [JSON]()

    func update() {
        defaults?.synchronize()
        if let restoredValue = defaults!.objectForKey("apps") {
            apps = JSON(restoredValue).array!
            print("ok", apps, restoredValue)
        }
        else {
            print("Cannot find value")
        }

        let height = (self.collectionView?.collectionViewLayout.collectionViewContentSize().height)!

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
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.backgroundColor = nil

        collectionView!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }

        update()

        NSNotificationCenter.defaultCenter().addObserverForName("adc", object: nil, queue: NSOperationQueue.mainQueue()) { (_) -> Void in
            self.update()
            self.collectionView!.reloadData()
        }
        app = self.extensionContext
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let index = indexPath.row
        cell.iconButton.setTitle(apps[index]["title"].string, forState: .Normal)
        cell.iconButton.addTarget(self, action: #selector(TodayViewController.actions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.titleLabel.text = apps[index]["title"].string

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(50, 50)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void))
    {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        dispatch_async(dispatch_get_main_queue(), {
            self.update()
            self.collectionView!.reloadData()
        })

        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    func actions(sender: AnyObject) {

        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? CollectionViewCell {
                    if let indexPath = collectionView!.indexPathForCell(cell) {
                        let type = apps[indexPath.row]["type"].string!
                        let action = apps[indexPath.row]["action"].string!
                        launchApp(type, action: action, extra: apps[indexPath.row]["extra"].string!, app: app)
                    }
                }
            }
        }
    }

}
