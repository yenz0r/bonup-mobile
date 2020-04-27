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
}

final class BenefitsView: UIViewController {

    // MARK: - Public variables

    var presenter: IBenefitsPresenter!

    // MARK: - Private UI variables

    private var segmentedControl: UISegmentedControl!
    private var collectionView: UICollectionView!

    // MARK: - Private Logic variables

    private var pages = [
        "ui_new_title".localized,
        "ui_salected_title".localized,
        "ui_used_title".localized
    ]

    // MARK: - Life cycle

    override func loadView() {
        self.view = UIView()

        self.segmentedControl = UISegmentedControl(items: self.pages)
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(40.0)
        }

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
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

        // self.view setup
        self.view.backgroundColor = .white

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
        self.collectionView.backgroundColor = .white

        self.collectionView.register(
            TasksListCurrentCollectionViewCell.self,
            forCellWithReuseIdentifier: TasksListCurrentCollectionViewCell.reuseId
        )
        self.collectionView.register(
            TasksListFinishedCollectionViewCell.self,
            forCellWithReuseIdentifier: TasksListFinishedCollectionViewCell.reuseId
        )
    }

    // MARK: - Configure

    private func configureAppearance() {
        self.view.backgroundColor = .white

        self.configureNavigationBar()
    }

    private func configureNavigationBar() {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = UIColor.red.withAlphaComponent(0.7)
        navigationItem.backBarButtonItem = backItem

        self.navigationItem.title = "ui_benefits_title".localized

        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = .purpleLite
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
        print("info")
    }
}

// MARK: - IBenefitsView

extension BenefitsView: IBenefitsView {
    func reloadData() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension BenefitsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
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
