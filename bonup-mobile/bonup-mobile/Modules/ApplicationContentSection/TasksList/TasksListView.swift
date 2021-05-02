//
//  TasksListView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITasksListView: AnyObject {
    func reloadData()
}

final class TasksListView: BUContentViewController {

    // MARK: - Public properties

    var presenter: ITasksListPresenter!

    // MARK: - Private properties

    private var segmentedControl: UISegmentedControl!
    private var mainCollectionView: UICollectionView!

    // MARK: - Life Cycle

    override func loadView() {
        self.view = UIView()

        self.segmentedControl = UISegmentedControl(items: [])
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(40.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }

        let mainCollectionFlowLayout = UICollectionViewFlowLayout()
        mainCollectionFlowLayout.scrollDirection = .horizontal
        mainCollectionFlowLayout.minimumLineSpacing = 0
        mainCollectionFlowLayout.minimumInteritemSpacing = 0
        self.mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mainCollectionFlowLayout)
        self.view.addSubview(self.mainCollectionView)
        self.mainCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(20.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.view setup
        self.view.theme_backgroundColor = Colors.backgroundColor

        // segmentedControl setup
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        // collectionView setup
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.allowsSelection = false
        self.mainCollectionView.showsHorizontalScrollIndicator = false
        self.mainCollectionView.contentInset = .zero
        self.mainCollectionView.isPagingEnabled = true
        self.mainCollectionView.backgroundColor = .clear

        self.mainCollectionView.register(
            TasksListCurrentCollectionViewCell.self,
            forCellWithReuseIdentifier: TasksListCurrentCollectionViewCell.reuseId
        )
        self.mainCollectionView.register(
            TasksListFinishedCollectionViewCell.self,
            forCellWithReuseIdentifier: TasksListFinishedCollectionViewCell.reuseId
        )

        self.configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.presenter.viewWillAppear()
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

        self.navigationItem.title = "tasks_list_title".localized

        let selectedIndex = self.segmentedControl.selectedSegmentIndex

        self.segmentedControl.removeAllSegments()

        for (index, page) in self.presenter.pages.enumerated() {

            self.segmentedControl.insertSegment(withTitle: page, at: index, animated: false)
        }

        self.segmentedControl.selectedSegmentIndex = selectedIndex
    }

    // MARK: - Configure

    private func configureNavigationBar() {

        let tasksListNavigationItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(clearHistoryTapped)
        )
        tasksListNavigationItem.theme_tintColor = Colors.navBarIconColor


        let infoButton = UIButton(type: .infoLight)
        infoButton.theme_tintColor = Colors.navBarIconColor
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem, tasksListNavigationItem]
    }

    // MARK: - Selectors

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
        self.mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func clearHistoryTapped() {

    }

    @objc private func infoNavigationItemTapped() {

    }
}

// MARK: - UICollectionViewDataSource implementation

extension TasksListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TasksListCurrentCollectionViewCell.reuseId,
                for: indexPath
            ) as! TasksListCurrentCollectionViewCell

            cell.presentationModels = self.presenter.currentTasksList
            cell.onSelect = { [weak self] index in
                self?.presenter.handleShowDetailsTap(with: index)
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TasksListFinishedCollectionViewCell.reuseId,
                for: indexPath
            ) as! TasksListFinishedCollectionViewCell

            cell.presentationModels = self.presenter.finishedTasksList

            return cell
        }
    }
}

// MARK: - UICollectionViewDataSource implementation

extension TasksListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - UIScrollViewDelegate

extension TasksListView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === self.mainCollectionView {
            self.segmentedControl.selectedSegmentIndex = Int(round(scrollView.contentOffset.x / self.mainCollectionView.frame.size.width))
        }
    }
    
}

// MARK: - ITaskListView implementation

extension TasksListView: ITasksListView {
    
    func reloadData() {
        self.mainCollectionView.reloadData()
    }
}
