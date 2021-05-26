//
//  BUTextField.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUTextField: UITextField {

    // MARK: - Public variables
    
    var loc_placeholder: String? {
        
        didSet {
            
            self.placeholder = loc_placeholder?.localized
            self.themeChanged()
        }
    }
    
    // MARK: - Initialization

    init() {

        super.init(frame: .zero)

        self.setupAppearance()
        self.setupObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeChanged),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)
    }

    private func setupAppearance() {

        self.theme_keyboardAppearance = Colors.keyboardAppearance
    }
    
    // MARK: - Selectors
    
    @objc private func langChanged() {
        
        let key = self.loc_placeholder
        self.loc_placeholder = key
    }
    
    @objc private func themeChanged() {
        
        let color: UIColor = ThemeColorsManager.shared.currentTheme == .dark ? .white : .black
        
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.5)]
        )
    }
}
