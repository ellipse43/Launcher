//
//  Prefs.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import Appz

extension Applications {

    struct Prefs: ExternalApplication {

        typealias ActionType = Applications.Prefs.Action

        let scheme = "prefs:"
        let fallbackURL = ""
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Prefs {

    enum Action {
        case safari
        case keyboard
    }
}

extension Applications.Prefs.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .safari:
            return ActionPaths(
                app: Path(
                    pathComponents: [],
                    queryParameters: [
                        "root": "Safari"
                    ]
                ),
                web: Path()
            )

        case .keyboard:
            return ActionPaths(
                app: Path(
                    pathComponents: [],
                    queryParameters: [
                        "root": "General",
                        "path": "Keyboard"
                    ]
                ),
                web: Path()
            )
        }
    }
}

// weixin


extension Applications {

    struct Weixin: ExternalApplication {

        typealias ActionType = Applications.Weixin.Action

        let scheme = "weixin:"
        let fallbackURL = "http://weixin.com"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Weixin {

    enum Action {
        case open
        case officialAccounts
        case scan
        case moments
        case profile
    }
}

extension Applications.Weixin.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )

        case .officialAccounts:
            return ActionPaths(
                app: Path(
                    pathComponents: ["dl", "officialaccounts"],
                    queryParameters: [:]
                ),
                web: Path()
            )

        case .scan:
            return ActionPaths(
                app: Path(
                    pathComponents: ["dl", "scan"],
                    queryParameters: [:]
                ),
                web: Path()
            )

        case .moments:
            return ActionPaths(
                app: Path(
                    pathComponents: ["dl", "moments"],
                    queryParameters: [:]
                ),
                web: Path()
            )

        case .profile:
            return ActionPaths(
                app: Path(
                    pathComponents: ["dl", "profile"],
                    queryParameters: [:]
                ),
                web: Path()
            )

        }
    }
}

// music 163

extension Applications {

    struct Orpheus: ExternalApplication {

        typealias ActionType = Applications.Orpheus.Action

        let scheme = "orpheus:"
        let fallbackURL = "http://music.163.com"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Orpheus {

    enum Action {
        case open
    }
}

extension Applications.Orpheus.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// baidumap

extension Applications {

    struct BaiduMap: ExternalApplication {

        typealias ActionType = Applications.BaiduMap.Action

        let scheme = "baidumap:"
        let fallbackURL = "http://map.baidu.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.BaiduMap {

    enum Action {
        case open
    }
}

extension Applications.BaiduMap.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// alipay

extension Applications {

    struct Alipay: ExternalApplication {

        typealias ActionType = Applications.Alipay.Action

        let scheme = "alipay:"
        let fallbackURL = "https://www.alipay.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Alipay {

    enum Action {
        case open
    }
}

extension Applications.Alipay.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// zhihu

extension Applications {

    struct Zhihu: ExternalApplication {

        typealias ActionType = Applications.Zhihu.Action

        let scheme = "zhihu:"
        let fallbackURL = "http://www.zhihu.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Zhihu {

    enum Action {
        case open
    }
}

extension Applications.Zhihu.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// bilibili

extension Applications {

    struct Bilibili: ExternalApplication {

        typealias ActionType = Applications.Bilibili.Action

        let scheme = "bilibili:"
        let fallbackURL = "http://www.bilibili.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.Bilibili {

    enum Action {
        case open
    }
}

extension Applications.Bilibili.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// diditaxi

extension Applications {

    struct DidiTaxi: ExternalApplication {

        typealias ActionType = Applications.DidiTaxi.Action

        let scheme = "diditaxi:"
        let fallbackURL = "http://www.xiaojukeji.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.DidiTaxi {

    enum Action {
        case open
    }
}

extension Applications.DidiTaxi.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}

// duokan-reader

extension Applications {

    struct DuokanReader: ExternalApplication {

        typealias ActionType = Applications.DuokanReader.Action

        let scheme = "duokan-reader:"
        let fallbackURL = "http://www.duokan.com/"
        let appStoreId = ""

        init() {}
    }
}

extension Applications.DuokanReader {

    enum Action {
        case open
    }
}

extension Applications.DuokanReader.Action: ExternalApplicationAction {

    var paths: ActionPaths {

        switch self {

        case .open:
            return ActionPaths(
                app: Path(
                    pathComponents: ["app"],
                    queryParameters: [:]
                ),
                web: Path()
            )
        }
    }
}
