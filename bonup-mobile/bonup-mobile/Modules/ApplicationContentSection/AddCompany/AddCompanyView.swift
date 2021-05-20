//
//  AddCompanyView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import Nuke

protocol IAddCompanyView: AnyObject {

    func setupImage(_ image: UIImage)
    func loadImage(_ url: URL, completion: @escaping (UIImage) -> Void)
}

final class AddCompanyView: BUContentViewController {

    // MARK: - Public variables

    var presenter: AddCompanyPresenter!

    // MARK: - UI variabes

    private var companyImageView: UIImageView!
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
        
        self.presenter.handleViewDidLoad()
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

        if self.presenter.moduleMode != .create {
            
            self.navigationItem.title = "ui_add_new_company".localized
            self.navigationItem.rightBarButtonItem?.title = "ui_done_title".localized
        }
        else {
            
            self.navigationItem.title = "ui_company_details_title".localized
        }
    }

    // MARK: - Setup

    private func setupNavBar() {

        let done: UIBarButtonItem
        
        if self.presenter.moduleMode != .read {
            
            done = UIBarButtonItem(title: "ui_done_title".localized,
                                   style: .plain,
                                   target: self,
                                   action: #selector(doneTapped))
        }
        else {
            
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

        self.view.addSubview(self.companyImageView)
        self.view.addSubview(self.categoriesContainer)
        self.view.addSubview(self.tableView)

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

    private func configureCompanyImageView() -> UIImageView {

        let iv = UIImageView()

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
    
    func setupImage(_ image: UIImage) {
        
        self.companyImageView.image = image
        self.presenter.selectedPhoto = image
    }
    
    func loadImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
        
        let imageRequest = ImageRequest(url: url)
        
        Nuke.loadImage(
            with: imageRequest,
            options: ImageLoadingOptions(),
            into: self.companyImageView,
            progress: nil) { result in
            
            switch result {
            
            case .success(let image):
                completion(image.image)
                
            default:
                break
            }
        }
    }
}
