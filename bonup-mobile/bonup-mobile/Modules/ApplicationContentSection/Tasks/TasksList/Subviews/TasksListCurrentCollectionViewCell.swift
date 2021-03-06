//
//  TasksListCurrentCollectionViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

final class TasksListCurrentCollectionViewCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    var presentationModels: [CurrentTasksListPresentationModel]? {
        didSet {
            
            self.collectionView.reloadData()
            self.collectionView.reloadEmptyDataSet()
        }
    }

    var onSelect: ((Int) -> Void)?

    // MARK: - Private variables

    private var collectionView: UICollectionView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        let collectionFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = BUCollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.collectionView.backgroundColor = .clear
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.emptyDataSetSource = self
        
        self.collectionView.register(
            CurrentTasksCollectionViewCell.self,
            forCellWithReuseIdentifier: CurrentTasksCollectionViewCell.reuseId
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UICollectionViewDataSource

extension TasksListCurrentCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentationModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrentTasksCollectionViewCell.reuseId,
            for: indexPath
        ) as! CurrentTasksCollectionViewCell

        cell.titleText = self.presentationModels?[indexPath.row].title
        cell.descriptionText = self.presentationModels?[indexPath.row].description
        cell.imageLink = self.presentationModels?[indexPath.row].imageLink
        cell.aliveTimeText = self.presentationModels?[indexPath.row].aliveTime

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TasksListCurrentCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect?(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TasksListCurrentCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40.0, height: 200.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}

// MARK: - EmptyDataSetSource

extension TasksListCurrentCollectionViewCell: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "ui_empty_current_tasks_list".localized,
                                  attributes: [.foregroundColor : Colors.textStateColor,
                                               .font: UIFont.avenirHeavy(20)])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return AssetsHelper.shared.image(.emptyTasksListIcon)?.resizedImage(targetSize: .init(width: 70,
                                                                                              height: 70))
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        
        return Colors.textStateColor
    }
}
