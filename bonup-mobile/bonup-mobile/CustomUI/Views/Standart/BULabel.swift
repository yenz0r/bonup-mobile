//
//  BULabel.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BULabel: UILabel {

    // MARK: - Public variables

    var loc_text: String? {

        didSet {

            self.text = (self.loc_text ?? "").localized
        }
    }

    // MARK: - Initialization

    init() {

        super.init(frame: .zero)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc private func langChanged() {

        self.text = self.loc_text?.localized
    }
}
