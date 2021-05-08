//
//  AddCompanyActionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol IAddCompanyActionView: AnyObject {

    func setupImage(_ image: UIImage)
}

final class AddCompanyActionView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IAddCompanyActionPresenter!

    // MARK: - UI variabes

    private var actionImageView: UIImageView!
    private var categoriesContainer: SelectCategoriesContainer!
    private var tableView: UITableView!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
        self.setupNavBar()
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

        self.navigationItem.title = self.presenter.screenTitle.localized
        self.navigationItem.rightBarButtonItem?.title = "ui_done_title".localized
    }

    // MARK: - Setup

    private func setupNavBar() {

        let done = UIBarButtonItem(title: "ui_done_title".localized,
                                   style: .plain,
                                   target: self,
                                   action: #selector(doneTapped))
        done.theme_tintColor = Colors.navBarIconColor
        self.navigationItem.rightBarButtonItem = done
    }

    private func setupSubviews() {

        self.actionImageView = self.configureActionImageView()
        self.categoriesContainer = self.configureCategoriesContainer()
        self.tableView = self.configureTableView()

        self.view.addSubview(self.actionImageView)
        self.view.addSubview(self.categoriesContainer)
        self.view.addSubview(self.tableView)

        self.actionImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }

        self.categoriesContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.actionImageView.snp.bottom).offset(10)
        }

        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.categoriesContainer.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    // MARK: - Configure

    private func configureActionImageView() -> UIImageView {

        let iv = UIImageView()

        iv.image = AssetsHelper.shared.image(.addImageIcon)
        iv.contentMode = .scaleAspectFit
        iv.theme_tintColor = Colors.navBarTextColor

        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        iv.addGestureRecognizer(gesture)
        iv.isUserInteractionEnabled = true

        return iv
    }

    private func configureCategoriesContainer() -> SelectCategoriesContainer {

        let dataSource = SelectCategoriesDataSource(
            selectedCategories: [self.presenter.selectedCategory],
            selectionMode: SelectCategoriesDataSource.SelectionMode.single
        )
        let container = SelectCategoriesContainer(delegate: self, dataSource: dataSource)

        return container
    }

    private func configureTableView() -> UITableView {

        let tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.tableFooterView = UIView()

        tableView.register(AddCompanyActionCell.self, forCellReuseIdentifier: AddCompanyActionCell.reuseId)

        return tableView
    }

    // MARK: - Selectors

    @objc private func imageViewTapped() {

        self.presenter.handleAddImageTap()
    }

    @objc private func doneTapped() {

        self.presenter.handleDoneTap()
    }
}

// MARK: - UITableViewDelegate

extension AddCompanyActionView: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension AddCompanyActionView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.presenter.fieldsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddCompanyActionCell.reuseId,
                                                 for: indexPath) as! AddCompanyActionCell

        cell.configure(with: self.presenter.fieldTitle(at: indexPath.row),
                       stringValue: self.presenter.fieldValue(at: indexPath.row),
                       fieldType: self.presenter.fieldType(at: indexPath.row))
        
        cell.onValueChange = { [weak self, indexPath] newValue in
            
            self?.presenter.handleValueUpdate(newValue, at: indexPath)
        }

        return cell
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension AddCompanyActionView: SelectCategoriesContainerDelegate {

    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {

        self.presenter.handleCategoriesUpdate(container.dataSource.selectedCategories)
    }
}

// MARK: - ISettingsParamsView

extension AddCompanyActionView: IAddCompanyActionView {
    
    func setupImage(_ image: UIImage) {
        
        self.actionImageView.image = image
    }
}
