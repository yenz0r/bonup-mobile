//
//  SelectCategoriesContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol SelectCategoriesContainerDelegate {

    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer)
}

protocol SelectCategoriesContainerDataSource {

    func numberOfCategoriesInSelectCategoriesContainer(_ container: SelectCategoriesContainer) -> Int
    func selectCategoriesContainer(_ container: SelectCategoriesContainer, cellModelAt index: Int) -> SelectCategoriesCellModel
    func selectCategoriesContainer(_ container: SelectCategoriesContainer, didSelectCategoryAt index: Int)

    var selectedCategories: [InterestCategories] { get }
}

final class SelectCategoriesContainer: UIView {

    // MARK: - Intialization

    init(delegate: SelectCategoriesContainerDelegate, dataSource: SelectCategoriesContainerDataSource) {

        self.delegate = delegate
        self.dataSource = dataSource

        super.init(frame: .zero)

        self.setupAppearance()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public variables

    private(set) var delegate: SelectCategoriesContainerDelegate
    private(set) var dataSource: SelectCategoriesContainerDataSource

    // MARK: - UI variables

    private var collectionView: UICollectionView!

    // MARK: - Setup

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    private func setupSubviews() {

        self.collectionView = self.configureCollectionView()

        self.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(SelectCategoriesCell.cellHeight)
        }
    }

    // MARK: - Configure

    private func configureCollectionView() -> UICollectionView {

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(SelectCategoriesCell.self,
                                forCellWithReuseIdentifier: SelectCategoriesCell.reuseId)

        return collectionView
    }
}

// MARK: - UICollectionViewDelegate

extension SelectCategoriesContainer: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.dataSource.selectCategoriesContainer(self, didSelectCategoryAt: indexPath.row)
        self.delegate.selectCategoriesContainerDidUpdateCategoriesList(self)
        
        for cell in collectionView.visibleCells {
            
            if let indexPath = collectionView.indexPath(for: cell),
               let categoryCell = cell as? SelectCategoriesCell {
                
                let model = self.dataSource.selectCategoriesContainer(self, cellModelAt: indexPath.row)
                categoryCell.configure(with: model)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SelectCategoriesContainer: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataSource.numberOfCategoriesInSelectCategoriesContainer(self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCategoriesCell.reuseId,
                                                      for: indexPath) as! SelectCategoriesCell

        let model = self.dataSource.selectCategoriesContainer(self, cellModelAt: indexPath.row)

        cell.configure(with: model)

        return cell
    }
}
