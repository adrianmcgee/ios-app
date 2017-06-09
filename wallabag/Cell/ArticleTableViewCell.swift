//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class ArticleTableViewCell: ThemedTableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var readingTime: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var readed: UIImageView!
    @IBOutlet weak var starred: UIImageView!

    func present(_ entry: Entry) {
        setupTheme()

        title.text = entry.title
        website.text = entry.domain_name

        if !entry.is_archived {
            title.font = UIFont.boldSystemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "unreaded")
        } else {
            title.font = UIFont.systemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "readed")
        }

        starred.image = entry.is_starred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")

        readingTime.text = String(format: "Reading time %@".localized, arguments: [Int(entry.reading_time).readingTime])

        guard let previewPicture = entry.preview_picture,
            let pictureURL = URL(string: previewPicture) else {
                previewImage.image = #imageLiteral(resourceName: "logo-icon-black-no-bg")
                return
        }

        previewImage.af_setImage(withURL: pictureURL)
    }

    override func setupTheme() {
        super.setupTheme()
        title?.textColor = Setting.getTheme().color
        website?.textColor = Setting.getTheme().color
        readingTime?.textColor = Setting.getTheme().color
        readed?.tintColor = Setting.getTheme().tintColor
        starred?.tintColor = Setting.getTheme().tintColor
    }
}
