//
//  BUTableView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import EmptyDataSet_Swift

class BUTableView: UITableView {
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero, style: .plain)
        
        self.setupObservers()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stateChanged),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stateChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func stateChanged() {
        
        self.reloadEmptyDataSet()
    }
}
