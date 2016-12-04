//
//  AppLauncher.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import Foundation
import Appz

public func launchApp(_ type: String, action: String, extra: String, app: ApplicationCaller) {

    switch type {

    case "phone":
        if action == "dial" {
            let number = extra
            app.open(Applications.Phone(), action: .open(number: number))
        }

    case "message":
        if action == "send" {
            let phone = extra
            app.open(Applications.Messages(), action: .sms(phone: phone))
        }

    case "gallery":
        if action == "open" {
            app.open(Applications.Gallery(), action: .open)
        }
    case "safari":
        if action == "open" {
            app.open(Applications.Prefs(), action: .keyboard)
        }
    case "setting":
        if action == "open" {
            app.open(Applications.AppSettings(), action: .open)
        }
    case "weixin":
        if action == "open" {
            app.open(Applications.Weixin(), action: .open)
        } else if action == "official_accounts" {
            app.open(Applications.Weixin(), action: .officialAccounts)
        } else if action == "scan" {
            app.open(Applications.Weixin(), action: .scan)
        } else if action == "profile" {
            app.open(Applications.Weixin(), action: .profile)
        } else if action == "moments" {
            app.open(Applications.Weixin(), action: .moments)
        }
    case "orpheus":
        if action == "open" {
            app.open(Applications.Orpheus(), action: .open)
        }
    case "alipay":
        if action == "open" {
            app.open(Applications.Alipay(), action: .open)
        }
    case "zhihu":
        if action == "open" {
            app.open(Applications.Zhihu(), action: .open)
        }
    case "bilibili":
        if action == "open" {
            app.open(Applications.Bilibili(), action: .open)
        }
    case "uber":
        if action == "open" {
            app.open(Applications.Uber(), action: .open)
        }
    case "diditaxi":
        if action == "open" {
            app.open(Applications.DidiTaxi(), action: .open)
        }
    case "duokan-reader":
        if action == "open" {
            app.open(Applications.DuokanReader(), action: .open)
        }
    case "baidumap":
        if action == "open" {
            app.open(Applications.BaiduMap(), action: .open)
        }
    case "weibo":
        if action == "open" {
            app.open(Applications.Weibo(), action: .open)
        }
    case "note":
        if action == "open" {
            app.open(Applications.Notes(), action: .open)
        }
    case "setting":
        if action == "open" {
            app.open(Applications.AppSettings(), action: .open)
        }

    default:
        print("item")
    }
}
