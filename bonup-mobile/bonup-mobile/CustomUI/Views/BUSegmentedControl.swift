//
//  BUSegmentedControl.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 5.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUSegmentedControl: UISegmentedControl {
    
    // MARK: - Private variables
    
    private let nonlocalizedItems: [String]
    
    // MARK: - Init
    
    init(nonlocalizedItems: [String]) {
        
        self.nonlocalizedItems = nonlocalizedItems
        
        super.init(items: [])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
        
        self.langChanged()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func langChanged() {
        
        let selectedIndex = self.selectedSegmentIndex
        
        self.removeAllSegments()
        
        for (index, title) in self.nonlocalizedItems.enumerated() {
            
            self.insertSegment(withTitle: title.localized,
                               at: index,
                               animated: false)
        }
        
        self.selectedSegmentIndex = selectedIndex
    }
}
