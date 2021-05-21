//
//  BUBarButtonItem.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

class BUBarButtonItem: UIBarButtonItem {
    
    // MARK: - Public variables

    var loc_title = "" {

        didSet {

            self.title = self.loc_title.localized
        }
    }
    
    // MARK: - Init
        
    init(loc_title: String,
         style: UIBarButtonItem.Style,
         target: AnyObject?,
         action: Selector?) {
        
        super.init()
        
        self.style = style
        self.target = target
        self.action = action
        
        self.loc_title = loc_title
        self.title = loc_title.localized
        
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

        self.title = self.loc_title.localized
    }
}
