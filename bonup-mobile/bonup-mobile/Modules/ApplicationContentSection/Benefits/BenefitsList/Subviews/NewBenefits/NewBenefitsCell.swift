//
//  NewBenefitsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

final class NewBenefitsCell: BenefitsCell {

    // MARK: - Static variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Public variables

    var presentationModels: [NewBenefitsPresentationModel]? {
        
        didSet {
            
            self.collectionView.reloadData()
            self.collectionView.reloadEmptyDataSet()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    var onSaveTap: ((Int) -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureCollectionView()
    }

    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configureCollectionView() {
        
        self.collectionView.dataSource = self
        self.collectionView.emptyDataSetSource = self
        
        self.collectionView.register(
            NewBenefitsContentCell.self,
            forCellWithReuseIdentifier: NewBenefitsContentCell.reuseId
        )
    }
}

// MARK: - UICollectionViewDataSource

extension NewBenefitsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentationModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewBenefitsContentCell.reuseId,
            for: indexPath
        )

        guard
            let benefitCell = cell as? NewBenefitsContentCell,
            let model = self.presentationModels?[indexPath.row] else {
            return cell
        }

        benefitCell.titleText = model.title
        benefitCell.descriptionText = model.description
        benefitCell.coastText = model.coast
        benefitCell.aliveTimeText = model.aliveTime
        benefitCell.onSaveTap = { [weak self] in

            self?.onSaveTap?(indexPath.row)
        }
        
        benefitCell.width = collectionView.frame.width

        return cell
    }
}

// MARK: - EmptyDataSetSource

extension NewBenefitsCell: EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "ui_empty_new_benefits_list".localized,
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
