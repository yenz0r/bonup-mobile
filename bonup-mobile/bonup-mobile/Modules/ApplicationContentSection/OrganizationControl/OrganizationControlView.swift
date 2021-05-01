//
//  OrganizationControlView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import SwiftQRScanner

protocol IOrganizationControlView: AnyObject {

    func reloadData()
    func dismissPresentedScanner()
}

final class OrganizationControlView: UIViewController {

    // MARK: - Data variables
    
    var presenter: IOrganizationControlPresenter!

    // MARK: - UI variables
    
    private var tableView: UITableView!

    // MARK: - Life Cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.configureAppearance()
    }
    
    // MARK: - Setup

    private func setupSubviews() {

        self.tableView = self.configureTableView()

        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in

            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }
    }
    
    // MARK: - Configure

    private func configureAppearance() {
        
        self.view.theme_backgroundColor = Colors.backgroundColor
        self.navigationItem.title = "ui_organization_title".localized
    }

    private func configureTableView() -> UITableView {

        let tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseId)

        return tableView
    }
}

// MARK: - UITableViewDataSource

extension OrganizationControlView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.presenter.numberOfControls()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseId, for: indexPath)

        guard let controlCell = cell as? SettingsTableViewCell else {

            return cell
        }

        controlCell.title = self.presenter.title(for: indexPath.row)
        controlCell.iconImage = self.presenter.icon(for: indexPath.row)
        controlCell.selectionStyle = .none

        return controlCell
    }
}

extension OrganizationControlView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.presenter.handleActionSelection(at: indexPath.row)
    }
}

extension OrganizationControlView: IOrganizationControlView {

    func reloadData() {

        self.tableView.reloadData()
    }
    
    func dismissPresentedScanner() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
