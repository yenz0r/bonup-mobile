//
//  SettingsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ISettingsView: AnyObject {
    func setupHeader(with image: UIImage?,
                     name: String,
                     email: String)

    func reloadData()
}

final class SettingsView: UIViewController {

    // MARK: - Public variables

    var presenter: SettingsPresenter!

    // MARK: - Private variables

    private var headerView: SettingsHeaderView!
    private var tableView: UITableView!

    // MARK: - Life Cycle

    override func loadView() {
        self.view = UIView()

        self.headerView = SettingsHeaderView()
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }

        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(8.0)
            make.top.equalTo(self.headerView.snp.bottom).offset(10.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "ui_settings_title".localized

        self.tableView.register(
            SettingsTableViewCell.self,
            forCellReuseIdentifier: SettingsTableViewCell.reuseId
        )
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        self.presenter.viewDidLoad()
    }
}

// MARK: - UITableViewDelegate

extension SettingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = SettingsPresenter.SettingsType(rawValue: indexPath.row)
        self.presenter.handleDidSelectSetting(for: type ?? .categories)
    }
}

// MARK: - UITableViewDataSource

extension SettingsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfSettings()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SettingsPresenter.SettingsType(rawValue: indexPath.row)
        let presentationModel = self.presenter.presentationModel(for: type ?? .categories)

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseId,
            for: indexPath
        ) as! SettingsTableViewCell

        cell.iconImage = presentationModel.icon
        cell.title = presentationModel.title
        cell.isLogout = presentationModel.isLogout

        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - ISettingsView

extension SettingsView: ISettingsView {
    func setupHeader(with image: UIImage?, name: String, email: String) {
        self.headerView.avatarImage = image
        self.headerView.name = name
        self.headerView.email = email
    }

    func reloadData() {
        self.tableView.reloadData()
    }
}
