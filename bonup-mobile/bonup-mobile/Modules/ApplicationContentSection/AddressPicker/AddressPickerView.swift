//
//  AddressPickerView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import UBottomSheet
import EmptyDataSet_Swift

protocol IAddressPickerView: AnyObject {

    func reloadData()
}

final class AddressPickerView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IAddressPickerPresenter!
    var sheetCoordinator: UBottomSheetCoordinator?
    var sheetCoordinatorDataSource: UBottomSheetCoordinatorDataSource?

    // MARK: - UI variabes

    private var searchBar: BUSearchBar!
    private var tableView: UITableView!
    private var doneButton: UIButton!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
        self.setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.sheetCoordinator?.startTracking(item: self)
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.searchBar = self.configureSearchBar()
        self.tableView = self.configureTableView()
        self.doneButton = self.configureDoneButton()
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.doneButton)
        
        self.searchBar.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        self.tableView.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
        
        self.doneButton.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(self.tableView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    // MARK: - Configure

    private func configureDoneButton() -> UIButton {

        let button = UIButton(type: .system)

        button.theme_backgroundColor = Colors.greenColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.avenirHeavy(20)
        button.theme_setTitleColor(Colors.backgroundColor, forState: .normal)

        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

        return button
    }
    
    private func configureTableView() -> UITableView {
        
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        tableView.register(AddressPickerSuggestCell.self, forCellReuseIdentifier: AddressPickerSuggestCell.reuseId)
        
        return tableView
    }
    
    private func configureSearchBar() -> BUSearchBar {
        
        let bar = BUSearchBar()
        
        bar.onSearchChange = { [weak self] text in
            
            self?.presenter.currentAddress = text
        }
        
        bar.placeholderLocalizationKey = "------"
        
        return bar
    }

    // MARK: - Selectors

    @objc private func doneTapped() {

        self.presenter.handleDoneButtonTap()
    }
}

// MARK: - UITableViewDelegate

extension AddressPickerView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let address = self.presenter.suggestions[indexPath.row]
        
        self.searchBar.value = address
        self.presenter.currentAddress = address
    }
}

// MARK: - UITableViewDataSource

extension AddressPickerView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.presenter.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressPickerSuggestCell.reuseId, for: indexPath) as! AddressPickerSuggestCell
        
        cell.setupTitle(self.presenter.suggestions[indexPath.row])
        
        return cell
    }
}

// MARK: - ICompanyCustomPacketView

extension AddressPickerView: IAddressPickerView {
    
    func reloadData() {
        
        self.tableView.reloadData()
        self.tableView.reloadEmptyDataSet()
    }
}

// MARK: - Draggable

extension AddressPickerView: Draggable {

    func draggableView() -> UIScrollView? {

        return self.tableView
    }
}

// MARK: - EmptyDataSetSource

extension AddressPickerView: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "lol kek".localized,
                                  attributes: [.foregroundColor : Colors.textStateColor,
                                               .font: UIFont.avenirHeavy(20)])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return AssetsHelper.shared.image(.emptyTasksListIcon)?.resizedImage(targetSize: .init(width: 70,
                                                                                              height: 70))
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        
        return Colors.textStateColor
    }
}

