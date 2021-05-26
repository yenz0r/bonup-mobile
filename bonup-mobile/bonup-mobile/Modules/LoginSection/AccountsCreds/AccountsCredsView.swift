//
//  AccountsCredsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

protocol IAccountsCredsView: AnyObject {
    
    func reloadData()
}

final class AccountsCredsView: BULoginViewController {

    // MARK: - Public variables

    var presenter: AccountsCredsPresenter!
    
    // MARK: - UI variables
    
    private var tableView: UITableView!

    // MARK: - Life cycle

    override func loadView() {
        
        self.view = UIView()

        self.setupSubviews()
        self.setupNavitionBar()
    }
    
    override func viewDidLoad() {
        
        self.presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupSubviews() {
        
        self.tableView = self.configureTableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNavitionBar() {
        
        self.navigationItem.title = "ui_accounts_title".localized
        
        let item = UIBarButtonItem(barButtonSystemItem: .trash,
                                   target: self,
                                   action: #selector(deleteAllTapped))
        
        self.navigationItem.rightBarButtonItem = item
    }
    
    // MARK: - Configure
    
    private func configureContentContainer() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .clear
        
        return container
    }

    private func configureTableView() -> UITableView {
        
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = .init()
        tableView.separatorStyle = .none
        
        tableView.register(AccountCredsCell.self, forCellReuseIdentifier: AccountCredsCell.reuseId)
        
        return tableView
    }
    
    // MARK: - Selectors
    
    @objc private func deleteAllTapped() {
     
        self.presenter.delegeAllItems()
    }
}

// MARK: - UITableViewDelegate

extension AccountsCredsView: UITableViewDelegate {
     
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.presenter.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        self.tableView.reloadEmptyDataSet()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.presenter.handleItemSelection(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension AccountsCredsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.presenter.accountsCreds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountCredsCell.reuseId,
                                                 for: indexPath) as! AccountCredsCell
        
        cell.configure(with: self.presenter.accountsCreds[indexPath.row])
        
        return cell
    }
}

// MARK: - IAuthVerificationView implementation

extension AccountsCredsView: IAccountsCredsView {
    
    func reloadData() {
        
        self.tableView.reloadData()
        self.tableView.reloadEmptyDataSet()
    }
}

// MARK: - EmptyDataSetSource

extension AccountsCredsView: EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "ui_emtpy_accounts_list".localized,
                                  attributes: [.foregroundColor : UIColor.white,
                                               .font: UIFont.avenirHeavy(20)])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return AssetsHelper.shared.image(.emptyTasksListIcon)?.resizedImage(targetSize: .init(width: 70,
                                                                                              height: 70))
    }
}
