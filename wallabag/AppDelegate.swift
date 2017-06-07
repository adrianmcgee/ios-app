//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit
import AlamofireNetworkActivityIndicator
import SwiftyBeaver
import CoreSpotlight
import Swinject

let log = SwiftyBeaver.self
let container: Container = {
    let container = Container()
    container.register(ArticleSync.self) { _ in
        ArticleSync()
        }.inObjectScope(.container)
    container.register(Setting.self) { _ in
        let sharedDomain = "group.wallabag.share_extension"
        return Setting(standard: UserDefaults.standard, shared: UserDefaults(suiteName: sharedDomain)!)
    }.inObjectScope(.container)
    return container
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let setting: Setting = container.resolve(Setting.self)!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        log.addDestination(ConsoleDestination())
        log.addDestination(FileDestination())
        log.addDestination(
            SBPlatformDestination(
                appID: "WxjB1g",
                appSecret: "rEwZssKhfnrcjniafpwjhmvtgcvuhCc6",
                encryptionKey: "j9tol59uyjd3w8okmhcKffggumkxlohi"
            )
        )
        CoreData.containerName = "wallabag2"

        let args = ProcessInfo.processInfo.arguments
        if args.contains("RESET_APPLICATION") {
            resetApplication()
        }

        WallabagApi.init(userStorage: UserDefaults(suiteName: "group.wallabag.share_extension")!)

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        log.debug(urls[urls.count-1] as URL)

        if !WallabagApi.isConfigured() {
            log.info("Wallabag api is not configured")
            window?.rootViewController = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home")
        } else {
            log.info("Wallabag api is configured")
        }

        requestBadge()
        updateBadge()

        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1

        ThemeManager.apply(theme: setting.getTheme())

        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if WallabagApi.isConfigured() {
            guard let mainController = window?.rootViewController! as? UINavigationController,
                let articlesTable = mainController.viewControllers.first as? ArticlesTableViewController else {
                    return false
            }
            articlesTable.restoreUserActivityState(userActivity)
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        updateBadge()
        CoreData.saveContext()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        if WallabagApi.isConfigured() {
            updateBadge()
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }

    private func requestBadge() {
        if setting.isBadgeEnable() {
            UIApplication.shared.setMinimumBackgroundFetchInterval(3600.0)
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    private func updateBadge() {
        if WallabagApi.isConfigured() {
            container.resolve(ArticleSync.self)!.sync()
        }
        log.info("Update badge")
        let request = Entry.fetchEntryRequest()
        switch setting.getDefaultMode() {
        case .unarchivedArticles:
            request.predicate = NSPredicate(format: "is_archived == 0")
            break
        case .starredArticles:
            request.predicate = NSPredicate(format: "is_starred == 1")
            break
        case .archivedArticles:
            request.predicate = NSPredicate(format: "is_archived == 1")
        default: break
        }

        UIApplication.shared.applicationIconBadgeNumber = ((CoreData.fetch(request) as? [Entry]) ?? []).count
    }
    
    func resetApplication() {
        setting.purge()
        CoreData.deleteAll("Entry")
    }
}
