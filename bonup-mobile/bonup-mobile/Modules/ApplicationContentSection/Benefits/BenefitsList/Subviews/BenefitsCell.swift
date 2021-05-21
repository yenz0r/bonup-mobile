//
//  BenefitsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

class BenefitsCell: UICollectionViewCell {

    // MARK: - UI variables

    internal var refreshControl: UIRefreshControl!
    internal var collectionView: UICollectionView!
    
    // MARK: - Public variables
    
    var onRefreshTriggered: (() -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.setupSubviewsForFrame(frame)
    }

    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup subviews

    private func setupSubviewsForFrame(_ frame: CGRect) {
        
        self.collectionView = self.configureCollectionViewForFrame(frame)
        self.refreshControl = self.configureRefreshControl()
        self.collectionView.refreshControl = self.refreshControl
        
        self.contentView.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10.0)
        }
    }
    
    // MARK: - Public functions
    
    func stopRefreshControl() {
        
        self.refreshControl.endRefreshing()
    }

    // MARK: - Configure

    private func configureCollectionViewForFrame(_ frame: CGRect) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 10.0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = BUCollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .clear

        return collectionView
    }
    
    private func configureRefreshControl() -> UIRefreshControl {
        
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(refreshControlDidTrigger), for: .valueChanged)
        refresh.tintColor = .systemRed
        
        return refresh
    }
    
    // MARK: - Selectors
    
    @objc private func refreshControlDidTrigger() {
        
        self.onRefreshTriggered?()
    }
}
