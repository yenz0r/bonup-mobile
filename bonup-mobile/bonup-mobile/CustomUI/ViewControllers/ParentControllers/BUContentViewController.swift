//
//  BUContentViewController.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

class BUContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizationChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)

        self.setupLocalizableContent()
    }

    @objc private func localizationChanged() {

        self.setupLocalizableContent()
    }

    func setupLocalizableContent() { }
}
