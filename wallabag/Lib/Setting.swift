//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit

class Setting {

    let sharedDomain = "group.wallabag.share_extension"
    let standard: UserDefaults
    let shared: UserDefaults

    init(standard: UserDefaults, shared: UserDefaults) {
        self.standard = standard
        self.shared = shared
    }

    enum RetrieveMode: String {
        case allArticles
        case archivedArticles
        case unarchivedArticles
        case starredArticles

        public func humainReadable() -> String {
            switch self {
            case .allArticles:
                return "All articles"
            case .archivedArticles:
                return "Read articles"
            case .starredArticles:
                return "Starred articles"
            case .unarchivedArticles:
                return "Unread articles"
            }
        }
    }

    enum Const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
        case badge
    }

    func getDefaultMode() -> RetrieveMode {
        guard let value = standard.string(forKey: Const.defaultMode.rawValue) else {
            return .allArticles
        }
        return RetrieveMode(rawValue: value)!
    }

    func setDefaultMode(mode: RetrieveMode) {
        standard.set(mode.rawValue, forKey: Const.defaultMode.rawValue)
    }

    func isJustifyArticle() -> Bool {
        return standard.bool(forKey: Const.justifyArticle.rawValue)
    }

    func setJustifyArticle(value: Bool) {
        standard.set(value, forKey: Const.justifyArticle.rawValue)
    }

    func isBadgeEnable() -> Bool {
        //enabled by default
        if nil == standard.object(forKey: Const.badge.rawValue) {
            return true
        }
        return standard.bool(forKey: Const.badge.rawValue)
    }

    func setBadgeEnable(value: Bool) {
        standard.set(value, forKey: Const.badge.rawValue)
    }

    func getTheme() -> ThemeManager.Theme {
        guard let value = standard.string(forKey: Const.articleTheme.rawValue) else {
            return .white
        }

        return ThemeManager.Theme(rawValue: value) ?? .white
    }

    func setTheme(value: ThemeManager.Theme) {
        standard.set(value.rawValue, forKey: Const.articleTheme.rawValue)
        ThemeManager.apply(theme: value)
    }

    func deleteServer() {
        shared.removeObject(forKey: "host")
        shared.removeObject(forKey: "clientId")
        shared.removeObject(forKey: "clientSecret")
        shared.removeObject(forKey: "username")
        shared.removeObject(forKey: "password")
        shared.removeObject(forKey: "token")
        shared.removeObject(forKey: "refreshToken")
        shared.synchronize()
    }

    func purge() {
        defer {
            standard.synchronize()
            shared.synchronize()
        }
        standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        deleteServer()
        shared.removeSuite(named: sharedDomain)
        shared.removePersistentDomain(forName: sharedDomain)
    }
}
