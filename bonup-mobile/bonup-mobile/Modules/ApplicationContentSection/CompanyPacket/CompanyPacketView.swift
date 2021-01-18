//
//  CompanyPacketView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyPacketView: AnyObject {

}

final class CompanyPacketView: BUContentViewController {

    // MARK: - Public variables

    var presenter: CompanyPacketPresenter!

    // MARK: - UI variabes

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

        self.navigationItem.title = "ui_add_new_company".localized
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

        self.tableView = self.configureTableView()

        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    // MARK: - Configure

    private func configureTableView() -> UITableView {

        let tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.tableFooterView = UIView()

        tableView.register(CompanyPacketCell.self, forCellReuseIdentifier: CompanyPacketCell.reuseId)

        return tableView
    }

    // MARK: - Selectors

    @objc private func doneTapped() {

    }
}

// MARK: - UITableViewDelegate

extension CompanyPacketView: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension CompanyPacketView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.presenter.packets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyPacketCell.reuseId,
                                                 for: indexPath) as! CompanyPacketCell

        cell.packetType = self.presenter.packets[indexPath.row]

        return cell
    }
}

// MARK: - ICompanyPacketView

extension CompanyPacketView: ICompanyPacketView { }
