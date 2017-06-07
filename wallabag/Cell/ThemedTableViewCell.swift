//
//  ThemedTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 18/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import Swinject

class ThemedTableViewCell: UITableViewCell {

    let setting: Setting = container.resolve(Setting.self)!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(forName: Notification.Name.themeUpdated, object: nil, queue: nil) { object in
            self.setupTheme()
        }

        setupTheme()
    }

    /**
     Apply the current theme to the cell
     */
    func setupTheme() {
        backgroundColor = setting.getTheme().backgroundColor
        textLabel?.textColor = setting.getTheme().color

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = setting.getTheme().backgroundSelectedColor
    }
}
