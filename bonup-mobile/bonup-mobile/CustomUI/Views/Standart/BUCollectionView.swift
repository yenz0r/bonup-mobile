//
//  BUCollectionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 9.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class BUCollectionView: UICollectionView {
    
    // MARK: - Init
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
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
