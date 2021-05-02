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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeChanged),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)

        self.setupLocalizableContent()
        self.setupThemeChangableContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                // NOTE: - Removing retain cycle in models - should be refactored!!!
                self.controllerDidTerminate()
            }
        }
    }
    
    @objc private func localizationChanged() {

        self.setupLocalizableContent()
    }
    
    @objc private func themeChanged() {
        
        self.setupThemeChangableContent()
    }

    func setupLocalizableContent() { }
    func setupThemeChangableContent() { }
    func controllerDidTerminate() { }
}
