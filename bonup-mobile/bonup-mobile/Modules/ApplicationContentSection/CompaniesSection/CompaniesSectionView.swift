//
//  CompaniesSectionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompaniesSectionView: AnyObject {

}

final class CompaniesSectionView: BUContentViewController {

    // MARK: - Public variables

    var presenter: ICompaniesSectionPresenter!

    // MARK: - UI variables

    private var segmentControl: UISegmentedControl!
    private var collectionView: UICollectionView!

    private var allCompaniesView: UIView!
    private var myCompaniesView: UIView!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
        self.setupNavBar()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
        self.setupChilds()
    }

    // MARK: - Setup

    private func setupChilds() {

        let myCompaniesDependecy = OrganizationsListDependency(parentNavigationController: self.navigationController!)
        let myCompaniesVC = OrganizationsListBuilder().build(myCompaniesDependecy)
        self.addChild(myCompaniesVC)
        self.myCompaniesView = myCompaniesVC.view
        myCompaniesVC.didMove(toParent: self)

        let allCompaniesDependency = CompaniesSearchDependency(parentNavigationController: self.navigationController!)
        let allCompaniesVC = CompaniesSearchBuilder().build(allCompaniesDependency)
        self.addChild(allCompaniesVC)
        self.allCompaniesView = allCompaniesVC.view
        allCompaniesVC.didMove(toParent: self)
    }

    private func setupSubviews() {

        self.segmentControl = self.configureSegmentControl()
        self.collectionView = self.configureCollectionView()

        self.navigationItem.titleView = self.segmentControl
        self.segmentControl.frame = CGRect(x: 0, y: 0, width: 160, height: 30)

        self.view.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    private func setupNavBar() {

        let infoButton = UIButton(type: .infoLight)
        infoButton.theme_tintColor = Colors.navBarIconColor
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ui_organization_title".localized,
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
        self.navigationItem.leftBarButtonItem?.theme_tintColor = Colors.defaultTextColor
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

        let selectedIndex = self.segmentControl.selectedSegmentIndex > 0 ? self.segmentControl.selectedSegmentIndex : 0

        self.segmentControl.removeAllSegments()

        for (index, page) in self.presenter.sections.enumerated() {

            self.segmentControl.insertSegment(withTitle: page, at: index, animated: false)
        }

        self.segmentControl.selectedSegmentIndex = selectedIndex

        self.navigationItem.leftBarButtonItem?.title = "ui_organization_title".localized
    }

    // MARK: - Configure

    private func configureSegmentControl() -> UISegmentedControl {

        let segmentControl = UISegmentedControl()

        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)

        return segmentControl
    }

    private func configureCollectionView() -> UICollectionView {

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sectionCell")

        return collectionView
    }

    // MARK: - Selectors

    @objc private func segmentControlChanged(_ sender: UISegmentedControl) {

//        let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
//        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let offset: CGFloat = sender.selectedSegmentIndex == 0 ? 0 : self.collectionView.frame.width
        self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }

    @objc private func infoNavigationItemTapped() {

        self.presenter.handleHelp(forSection: self.segmentControl.selectedSegmentIndex)
    }
}

// MARK: - UIScrollViewDelegate

extension CompaniesSectionView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === self.collectionView {

            self.segmentControl.selectedSegmentIndex = Int(round(scrollView.contentOffset.x / self.collectionView.frame.size.width))
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CompaniesSectionView: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension CompaniesSectionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.presenter.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        var content: UIView
        if indexPath.row == 0 {

            content = self.allCompaniesView
        }
        else {

            content = self.myCompaniesView
        }

        cell.contentView.addSubview(content)
        content.frame = cell.contentView.bounds

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompaniesSectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.collectionView.frame.size
    }
}

// MARK: - ICompaniesSectionView impl

extension CompaniesSectionView: ICompaniesSectionView { }
