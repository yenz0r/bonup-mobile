//
//  BUNavigationController.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class BUNavigationController: UINavigationController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true

        let textAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.purpleLite.withAlphaComponent(0.7),
            .font: UIFont.avenirRoman(20)
        ]
        self.navigationBar.titleTextAttributes = textAttributes

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = UIColor.red.withAlphaComponent(0.7)
        self.navigationItem.backBarButtonItem = backItem
    }

    // MARK: - Public Functions

    func setupTabBarItem(with title: String,
                      unselectedImage: UIImage?,
                      selectedImage: UIImage?) {
        self.tabBarItem = UITabBarItem(
            title: title,
            image: unselectedImage,
            selectedImage: selectedImage
        )
    }
}
