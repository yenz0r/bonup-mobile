//
//  CompanyActionsAggregatorView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyActionsAggregatorView: AnyObject { }

final class CompanyActionsAggregatorView: BUContentViewController {

    // MARK: - Public variables

    var presenter: ICompanyActionsAggregatorPresenter!

    // MARK: - UI variables

    private var segmentControl: BUSegmentedControl!
    private var collectionView: UICollectionView!

    // MARK: - Childrend's views
    
    private var tasksSectionView: UIView!
    private var couponsSectionView: UIView!
    private var stocksSectionView: UIView!

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

        let tasksSectionDependecy = CompanyActionsListDependency(parentNavigationController: self.navigationController!,
                                                                 contentType: .tasks,
                                                                 contentMode: .load(organizationName: self.presenter.companyName),
                                                                 actions: nil)
        let tasksSectionVC: UIViewController = CompanyActionsListBuilder().build(tasksSectionDependecy)
        self.addChild(tasksSectionVC)
        self.tasksSectionView = tasksSectionVC.view
        tasksSectionVC.didMove(toParent: self)
        
        let couponsSectionDependecy = CompanyActionsListDependency(parentNavigationController: self.navigationController!,
                                                                 contentType: .coupons,
                                                                 contentMode: .load(organizationName: self.presenter.companyName),
                                                                 actions: nil)
        let couponsSectionVC: UIViewController = CompanyActionsListBuilder().build(couponsSectionDependecy)
        self.addChild(couponsSectionVC)
        self.couponsSectionView = couponsSectionVC.view
        couponsSectionVC.didMove(toParent: self)
        
        let stocksSectionDependecy = CompanyActionsListDependency(parentNavigationController: self.navigationController!,
                                                                  contentType: .stocks,
                                                                  contentMode: .load(organizationName: self.presenter.companyName),
                                                                  actions: nil)
        let stocksSectionVC: UIViewController = CompanyActionsListBuilder().build(stocksSectionDependecy)
        self.addChild(stocksSectionVC)
        self.stocksSectionView = stocksSectionVC.view
        stocksSectionVC.didMove(toParent: self)
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
        
        self.loc_title = "ui_actions_title"

        let infoButton = UIButton(type: .infoLight)
        infoButton.theme_tintColor = Colors.navBarIconColor
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem]
    }

    // MARK: - Configure

    private func configureSegmentControl() -> BUSegmentedControl {

        let segmentControl = BUSegmentedControl(nonlocalizedItems: self.presenter.sections)

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
        collectionView.isScrollEnabled = false

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sectionCell")

        return collectionView
    }

    // MARK: - Selectors

    @objc private func segmentControlChanged(_ sender: UISegmentedControl) {

//        let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
//        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let offset: CGFloat = CGFloat(sender.selectedSegmentIndex) * self.collectionView.frame.width
        self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        
        self.view.endEditing(true)
    }

    @objc private func infoNavigationItemTapped() {

        self.presenter.handleHelp(forSection: self.segmentControl.selectedSegmentIndex)
    }
}

// MARK: - UIScrollViewDelegate

extension CompanyActionsAggregatorView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === self.collectionView {

            self.segmentControl.selectedSegmentIndex = Int(round(scrollView.contentOffset.x / self.collectionView.frame.size.width))
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CompanyActionsAggregatorView: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension CompanyActionsAggregatorView: UICollectionViewDataSource {

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

            content = self.tasksSectionView
        }
        else if indexPath.row == 1 {

            content = self.couponsSectionView
        }
        else {
            
            content = self.stocksSectionView
        }

        cell.contentView.addSubview(content)
        content.snp.makeConstraints { $0.edges.equalToSuperview()
            $0.size.equalTo(cell.frame.size)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanyActionsAggregatorView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

// MARK: - ICompaniesSectionView impl

extension CompanyActionsAggregatorView: ICompanyActionsAggregatorView { }

