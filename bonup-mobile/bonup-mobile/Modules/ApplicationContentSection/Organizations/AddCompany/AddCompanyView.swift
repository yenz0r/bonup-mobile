//
//  AddCompanyView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol IAddCompanyView: AnyObject {

    func updateBlurState(active state: Bool)
    func reloadRow(at indexPath: IndexPath)
    func setupImage(_ image: UIImage)
    func loadImage(_ url: URL, completion: @escaping (UIImage) -> Void)
}

final class AddCompanyView: BUContentViewController {

    // MARK: - Public variables

    var presenter: AddCompanyPresenter!

    // MARK: - UI variabes

    private var blurView: UIView!
    private var companyImageView: BULoadImageView!
    private var categoriesContainer: SelectCategoriesContainer!
    private var tableView: UITableView!
    
    // MARK: - State variables
    
    private var isFirstLayout = true

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
        self.setupNavBar()
        
        self.presenter.handleViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if (self.isFirstLayout) {

            self.blurView.setupBlur()
            self.isFirstLayout.toggle()
        }
    }

    // MARK: - Setup

    private func setupNavBar() {

        let done: UIBarButtonItem
        
        if self.presenter.moduleMode != .read {
            
            self.loc_title = self.presenter.moduleMode == .create ? "ui_add_new_company" : "ui_modify_company_title"
            
            done = BUBarButtonItem(loc_title: "ui_done_title",
                                   style: .plain,
                                   target: self,
                                   action: #selector(doneTapped))
        }
        else {
            
            self.loc_title = "ui_company_details_title"
            
            done = UIBarButtonItem(barButtonSystemItem: .organize,
                                   target: self,
                                   action: #selector(actionsAggregatorTapped))
        }
        
        done.theme_tintColor = Colors.navBarIconColor
        self.navigationItem.rightBarButtonItem = done
    }

    private func setupSubviews() {

        self.companyImageView = self.configureCompanyImageView()
        self.categoriesContainer = self.configureCategoriesContainer()
        self.tableView = self.configureTableView()
        self.blurView = self.configureBlurView()
        
        self.view.addSubview(self.companyImageView)
        self.view.addSubview(self.categoriesContainer)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.blurView)
        
        self.blurView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        self.companyImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }

        self.categoriesContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.companyImageView.snp.bottom).offset(10)
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
    
    private func configureBlurView() -> UIView {
        
        let blur = UIView()
        
        blur.backgroundColor = .clear
        blur.alpha = 0
        blur.isUserInteractionEnabled = false
        
        return blur
    }

    private func configureCompanyImageView() -> BULoadImageView {

        let iv = BULoadImageView()

        iv.image = self.presenter.selectedPhoto
        iv.contentMode = .scaleAspectFit
        iv.theme_tintColor = Colors.navBarTextColor

        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        iv.addGestureRecognizer(gesture)
        iv.isUserInteractionEnabled = self.presenter.moduleMode != .read

        return iv
    }

    private func configureCategoriesContainer() -> SelectCategoriesContainer {

        let dataSource = SelectCategoriesDataSource(selectedCategories: [self.presenter.selectedCategory],
                                                    selectionMode: .single,
                                                    isChangable: self.presenter.moduleMode != .read)
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

        tableView.register(AddCompanyInputCell.self, forCellReuseIdentifier: AddCompanyInputCell.reuseId)

        return tableView
    }

    // MARK: - Selectors

    @objc private func imageViewTapped() {

        self.presenter.handleAddImageTap()
    }

    @objc private func doneTapped() {

        self.view.endEditing(true)
        
        self.presenter.handleDoneTap()
    }
    
    @objc private func actionsAggregatorTapped() {
        
        self.presenter.handleActionsAggregatorTap()
    }
}

// MARK: - UITableViewDelegate

extension AddCompanyView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = AddCompanyInputHeader(frame: .zero)

        header.title = self.presenter.inputSections[section].title

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 50
    }
}

// MARK: - UITableViewDataSource

extension AddCompanyView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.presenter.inputSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.presenter.inputSections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddCompanyInputCell.reuseId,
                                                 for: indexPath) as! AddCompanyInputCell

        cell.configure(with: self.presenter.inputSections[indexPath.section].rows[indexPath.row])
        
        cell.onValueChange = { [weak self, indexPath] newValue in
            
            self?.presenter.handleValueUpdate(newValue, at: indexPath)
        }
        
        cell.onTap = { [weak self] in
            
            self?.presenter.handleAddressTap()
        }

        return cell
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension AddCompanyView: SelectCategoriesContainerDelegate {

    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {

        self.presenter.handleSectionsUpdate(categories: container.dataSource.selectedCategories)
    }
}

// MARK: - ISettingsParamsView

extension AddCompanyView: IAddCompanyView {
    
    func updateBlurState(active state: Bool) {

        UIView.animate(withDuration: 0.3) {

            self.blurView.alpha = state ? 1 : 0
            self.blurView.isUserInteractionEnabled = state
        }
    }
    
    func reloadRow(at indexPath: IndexPath) {
        
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func setupImage(_ image: UIImage) {
        
        self.companyImageView.image = image
        self.presenter.selectedPhoto = image
    }
    
    func loadImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
        
        self.companyImageView.loadFrom(url: url)
    }
}
