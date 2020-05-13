//
//  SelectedBenefitsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class SelectedBenefitsCell: BenefitsCell {

    // MARK: - Static variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Public variables

    var presentationModels: [SelectedBenefitsPresentationModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    var onBenefitSelect: ((Int) -> Void)?

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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            SelectedBenefitsContentCell.self,
            forCellWithReuseIdentifier: SelectedBenefitsContentCell.reuseId
        )
    }

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

//        self.presentationModels = nil
    }
}

// MARK: - UICollectionViewDelegate

extension SelectedBenefitsCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width - 20, height: 70)
    }
}

extension SelectedBenefitsCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.onBenefitSelect?(indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension SelectedBenefitsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentationModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectedBenefitsContentCell.reuseId,
            for: indexPath
        )

        guard
            let benefitCell = cell as? SelectedBenefitsContentCell,
            let model = self.presentationModels?[indexPath.row] else {
            return cell
        }

        benefitCell.titleText = model.title
        benefitCell.descriptionText = model.description
        benefitCell.coastText = model.coast

        return cell
    }
}
