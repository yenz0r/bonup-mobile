//
//  BUMapView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import YandexMapsMobile

final class BUMapView: YMKMapView {

    // MARK: - Initiazalization

    init() {
        super.init(frame: .zero)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeChanged(_:)),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged(_:)),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)

        self.themeChanged(Notification(name: ThemeColorsManager.shared.notificationName))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc private func langChanged(_ notification: Notification) {
    
        
    }
        
    @objc private func themeChanged(_ notification: Notification) {

        var theme: ThemeColorsManager.Themes

        if let new = notification.userInfo?["theme"] as? ThemeColorsManager.Themes {

            theme = new
        }
        else {

            theme = ThemeColorsManager.shared.currentTheme
        }

        switch theme {
        case .light:
            self.mapWindow.map.isNightModeEnabled = false
        case .dark:
            self.mapWindow.map.isNightModeEnabled = true
        }
    }
}
