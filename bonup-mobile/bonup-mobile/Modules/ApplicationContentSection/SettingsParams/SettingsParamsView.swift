//
//  SettingsParamsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ISettingsParamsView: AnyObject {

}

final class SettingsParamsView: UIViewController {

    // MARK: - Public variables

    var presenter: SettingsParamsPresenter!

    // MARK: - Private variables

    private var tableView: UITableView!

    // MARK: - Life Cycle

    override func loadView() {
        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupNavigation()
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.tableView = self.configureTableView()
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    private func setupNavigation() {

        self.navigationItem.title = "ui_settings_title".localized
    }

    // MARK: - Configure

    private func configureTableView() -> UITableView {

        let tableView = UITableView()

        tableView.register(
            SettingsParamsCell.self,
            forCellReuseIdentifier: SettingsParamsCell.reuseId
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear

        return tableView
    }
}

// MARK: - UITableViewDelegate

extension SettingsParamsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return SettingsParamsCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.presenter.handleItemSelection(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SettingsParamsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.presenter.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseId,
            for: indexPath
        ) as! SettingsParamsCell


        cell.configure(with: self.presenter.itemForRow(indexPath.row))
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - ISettingsParamsView

extension SettingsParamsView: ISettingsParamsView { }
