//
//  AppsViewController.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items = JSON([])

    lazy var tableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section]["items"].count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddViewController()
        vc.item = items[indexPath.section]["items"][indexPath.row]
        navigationController!.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section]["name"].string
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")

        if let v = items[indexPath.section]["items"][indexPath.row]["name"].string {
            cell.textLabel!.text = v
        }
        return cell
    }

}
