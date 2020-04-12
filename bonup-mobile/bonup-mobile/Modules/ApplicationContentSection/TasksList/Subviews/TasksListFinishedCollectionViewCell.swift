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

    var presentationModels: [FinishedTasksListPresentationModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Private variables

    private var collectionView: UICollectionView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        let collectionFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            FinishedTasksCollectionViewCell.self,
            forCellWithReuseIdentifier: FinishedTasksCollectionViewCell.reuseId
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension TasksListFinishedCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentationModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FinishedTasksCollectionViewCell.reuseId,
            for: indexPath
        ) as! FinishedTasksCollectionViewCell

        cell.titleText = self.presentationModels?[indexPath.row].title
        cell.descriptionText = self.presentationModels?[indexPath.row].description
        cell.benefitText = self.presentationModels?[indexPath.row].benefit
        cell.dateOfEndText = self.presentationModels?[indexPath.row].dateOfEnd
        cell.isDone = self.presentationModels?[indexPath.row].isDone

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TasksListFinishedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20.0, height: 70.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
