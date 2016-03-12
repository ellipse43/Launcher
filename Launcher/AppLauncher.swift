//
//  AppLauncher.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import Foundation
import Appz

public func launchApp(type: String, action: String, extra: String, app: ApplicationCaller) {

    switch type {

    case "phone":
        if action == "dial" {
            let number = extra
            app.open(Applications.Phone(), action: .Open(number: number))
        }

    case "message":
        if action == "send" {
            let phone = extra
            app.open(Applications.Messages(), action: .SMS(phone: phone))
        }

    case "gallery":
        if action == "open" {
            app.open(Applications.Gallery(), action: .Open)
        }
    case "safari":
        if action == "open" {
            app.open(Applications.Prefs(), action: .Keyboard)
        }
    case "setting":
        if action == "open" {
            app.open(Applications.AppSettings(), action: .Open)
        }
    case "weixin":
        if action == "open" {
            app.open(Applications.Weixin(), action: .Open)
        } else if action == "official_accounts" {
            app.open(Applications.Weixin(), action: .OfficialAccounts)
        } else if action == "scan" {
            app.open(Applications.Weixin(), action: .Scan)
        } else if action == "profile" {
            app.open(Applications.Weixin(), action: .Profile)
        } else if action == "moments" {
            app.open(Applications.Weixin(), action: .Moments)
        }
    case "orpheus":
        if action == "open" {
            app.open(Applications.Orpheus(), action: .Open)
        }
    case "alipay":
        if action == "open" {
            app.open(Applications.Alipay(), action: .Open)
        }
    case "zhihu":
        if action == "open" {
            app.open(Applications.Zhihu(), action: .Open)
        }
    case "bilibili":
        if action == "open" {
            app.open(Applications.Bilibili(), action: .Open)
        }
    case "uber":
        if action == "open" {
            app.open(Applications.Uber(), action: .Open)
        }
    case "diditaxi":
        if action == "open" {
            app.open(Applications.DidiTaxi(), action: .Open)
        }
    case "duokan-reader":
        if action == "open" {
            app.open(Applications.DuokanReader(), action: .Open)
        }
    case "baidumap":
        if action == "open" {
            app.open(Applications.BaiduMap(), action: .Open)
        }
    case "weibo":
        if action == "open" {
            app.open(Applications.Weibo(), action: .Open)
        }
    case "note":
        if action == "open" {
            app.open(Applications.Notes(), action: .Open)
        }
    case "setting":
        if action == "open" {
            app.open(Applications.AppSettings(), action: .Open)
        }

    default:
        print("item")
    }
}
