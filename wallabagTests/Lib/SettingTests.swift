//
//  SettingTests.swift
//  wallabag
//
//  Created by maxime marinel on 02/06/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class SettingTests: XCTestCase {

    override func tearDown() {
        Setting.purge()
    }

    func testSettingRetrieveModeAllArticlesHumainReadable() {
        XCTAssertEqual("All articles", Setting.RetrieveMode.allArticles.humainReadable())
    }

    func testSettingRetrieveModeArchivedArticlesHumainReadable() {
        XCTAssertEqual("Read articles", Setting.RetrieveMode.archivedArticles.humainReadable())
    }

    func testSettingRetrieveModeStarredArticlesHumainReadable() {
        XCTAssertEqual("Starred articles", Setting.RetrieveMode.starredArticles.humainReadable())
    }

    func testSettingRetrieveModeUnarchivedArticlesHumainReadable() {
        XCTAssertEqual("Unread articles", Setting.RetrieveMode.unarchivedArticles.humainReadable())
    }

    func testSettingGetDefaultModeReturnAllArticleByDefault() {
        XCTAssertEqual(Setting.RetrieveMode.allArticles, Setting.getDefaultMode())
    }

    func testSettingSetDefaultMode() {
        Setting.setDefaultMode(mode: .archivedArticles)
        XCTAssertEqual(Setting.RetrieveMode.archivedArticles, Setting.getDefaultMode())
    }

    func testSettingIsJustifyArticle() {
        XCTAssertFalse(Setting.isJustifyArticle())
    }

    func testSettingSetJustifyArticle() {
        Setting.setJustifyArticle(value: true)
        XCTAssertTrue(Setting.isJustifyArticle())
    }

    func testSettingIsBadgeEnable() {
        XCTAssertTrue(Setting.isBadgeEnable())
    }

    func testSettingSetBadgeEnable() {
        Setting.setBadgeEnable(value: false)
        XCTAssertFalse(Setting.isBadgeEnable())
    }

    func testSettingGetThemeByDefaultWhite() {
        XCTAssertEqual(ThemeManager.Theme.white, Setting.getTheme())
    }

    func testSettingSetTheme() {
        Setting.setTheme(value: .light)
        XCTAssertEqual(ThemeManager.Theme.light, Setting.getTheme())
    }

    func testSettingPurge() {
        Setting.shared.set("myHost", forKey: "host")
        Setting.shared.set("myClientId", forKey: "clientId")
        Setting.shared.set("myClientSecret", forKey: "clientSecret")
        Setting.shared.set("myUsername", forKey: "username")
        Setting.shared.set("myPassword", forKey: "password")
        Setting.shared.set("myToken", forKey: "token")
        Setting.shared.set("myRefreshToken", forKey: "refreshToken")

        XCTAssertEqual("myHost", Setting.shared.string(forKey: "host"))
        XCTAssertEqual("myClientId", Setting.shared.string(forKey: "clientId"))
        XCTAssertEqual("myClientSecret", Setting.shared.string(forKey: "clientSecret"))
        XCTAssertEqual("myUsername", Setting.shared.string(forKey: "username"))
        XCTAssertEqual("myPassword", Setting.shared.string(forKey: "password"))
        XCTAssertEqual("myToken", Setting.shared.string(forKey: "token"))
        XCTAssertEqual("myRefreshToken", Setting.shared.string(forKey: "refreshToken"))

        Setting.deleteServer()

        XCTAssertEqual(nil, Setting.shared.string(forKey: "host"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "clientId"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "clientSecret"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "username"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "password"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "token"))
        XCTAssertEqual(nil, Setting.shared.string(forKey: "refreshToken"))
    }
}
