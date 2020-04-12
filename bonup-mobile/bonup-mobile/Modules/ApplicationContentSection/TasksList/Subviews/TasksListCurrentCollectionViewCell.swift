//
//  TasksListCurrentCollectionViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class TasksListCurrentCollectionViewCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UICollectionViewDataSource

extension TasksListCurrentCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension TasksListCurrentCollectionViewCell: UICollectionViewDelegate {

}

// MARK: - UICollectionView

extension TasksListCurrentCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
}
