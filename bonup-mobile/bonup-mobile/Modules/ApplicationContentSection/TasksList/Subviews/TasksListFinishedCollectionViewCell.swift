//
//  TasksListFinishedCollectionViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class TasksListFinishedCollectionViewCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
