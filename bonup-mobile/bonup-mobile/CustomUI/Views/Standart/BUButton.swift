//
//  BUButton.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

class BUButton: UIButton {
    
    // MARK: - Public variables

    var loc_title: String? {

        didSet {

            self.setTitle((self.loc_title ?? "").localized, for: .normal)
        }
    }
        
    // MARK: - Life cycle
    
    override func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
    }

    // MARK: - Selectors

    @objc private func langChanged() {

        self.setTitle(self.loc_title?.localized, for: .normal)
    }
}
