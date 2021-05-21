//
//  BenefitsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitsView: AnyObject {
    
    func reloadData()
    func stopRefreshControls()
}

final class BenefitsView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IBenefitsPresenter!

    // MARK: - Private UI variables

    private var segmentedControl: UISegmentedControl!
    private var collectionView: UICollectionView!

    // MARK: - Life cycle

    override func loadView() {
        self.view = UIView()

        self.segmentedControl = BUSegmentedControl(nonlocalizedItems: self.presenter.pages)
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8.0)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(40.0)
        }

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(8.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureAppearance()
        self.configureNavigationBar()

        // segmentedControl setup
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        // collectionView setup
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = .zero
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .clear

        self.collectionView.register(
            NewBenefitsCell.self,
            forCellWithReuseIdentifier: NewBenefitsCell.reuseId
        )
        self.collectionView.register(
            SelectedBenefitsCell.self,
            forCellWithReuseIdentifier: SelectedBenefitsCell.reuseId
        )
        self.collectionView.register(
            UsedBenefitsCell.self,
            forCellWithReuseIdentifier: UsedBenefitsCell.reuseId
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.presenter.refreshData()
    }

    // MARK: - Configure

    private func configureAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
        self.collectionView.backgroundColor = .clear
    }

    private func configureNavigationBar() {

        self.loc_title = "ui_benefits_title"
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.theme_tintColor = Colors.navBarIconColor
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem]
    }

    // MARK: - Selectors

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {

        let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func infoNavigationItemTapped() {

        self.presenter.handleShowHelpAction()
    }
}

// MARK: - IBenefitsView

extension BenefitsView: IBenefitsView {
    
    func reloadData() {
        
        self.collectionView.reloadData()
    }
    
    func stopRefreshControls() {
        
        for cell in self.collectionView.visibleCells {
            
            if let benefitCell = cell as? BenefitsCell {
                
                benefitCell.stopRefreshControl()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BenefitsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.pages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var parentCell: BenefitsCell
        
        switch indexPath.row {
        case 0:

            let cell = collectionView .dequeueReusableCell(
                withReuseIdentifier: NewBenefitsCell.reuseId,
                for: indexPath
            ) as! NewBenefitsCell

            let presentationModels = self.presenter.savedBenfits.map {
                return NewBenefitsPresentationModel(
                            title: $0.name,
                            description: $0.description,
                            coast: "\($0.costCount)",
                            aliveTime: $0.dateTo
                        )
            }
            cell.presentationModels = presentationModels
            cell.onSaveTap = { [weak self] index in

                self?.presenter.handleBuyBenefit(for: index)
            }
            
            parentCell = cell
            
        case 1:

            let cell = collectionView .dequeueReusableCell(
                withReuseIdentifier: SelectedBenefitsCell.reuseId,
                for: indexPath
            ) as! SelectedBenefitsCell

            let presentationModels = self.presenter.boughtBenfits.map { benefit in
                return SelectedBenefitsPresentationModel(
                    title: benefit.name,
                    description: benefit.description,
                    coast: "\(benefit.costCount)"
                )
            }

            cell.presentationModels = presentationModels
            cell.onBenefitSelect = { [weak self] index in

                self?.presenter.handleShowDescription(for: index)
            }
            
            parentCell = cell
            
        case 2:

            let cell = collectionView .dequeueReusableCell(
                withReuseIdentifier: UsedBenefitsCell.reuseId,
                for: indexPath
            ) as! UsedBenefitsCell

            let presentationModels = self.presenter.finishedBenefits.map {  benefit in
                return UsedBenefitsPresentationModel(
                    title: benefit.name,
                    description: benefit.description,
                    dateOfUse: benefit.dateTo,
                    isDied: benefit.isDied
                )
            }

            cell.presentationModels = presentationModels
            
            parentCell = cell

        default:
            let cell = UICollectionViewCell()
            return cell
        }
        
        parentCell.onRefreshTriggered = { [weak self] in
            
            self?.presenter.refreshData()
        }
        
        return parentCell
    }
}

// MARK: - UICollectionDelegateFlowLayout

extension BenefitsView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UIScrollViewDelegate

extension BenefitsView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === self.collectionView {
            self.segmentedControl.selectedSegmentIndex = Int(round(scrollView.contentOffset.x / self.collectionView.frame.size.width))
        }
    }
}
