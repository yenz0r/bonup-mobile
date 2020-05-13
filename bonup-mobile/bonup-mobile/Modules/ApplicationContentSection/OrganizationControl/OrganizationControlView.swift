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
}

final class OrganizationControlView: UIViewController {

    var presenter: IOrganizationControlPresenter!

    private var tableView: UITableView!

    private var currentIndex: Int!

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.configureAppearance()
    }

    private func setupSubviews() {

        self.tableView = self.configureTableView()

        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in

            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }
    }

    private func configureAppearance() {
        self.view.backgroundColor = .white

        self.navigationItem.title = "ui_organization_title".localized
    }

    private func configureTableView() -> UITableView {

        let tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseId)

        return tableView
    }
}

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
        
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.currentIndex = indexPath.row
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension OrganizationControlView: IOrganizationControlView {

    func reloadData() {

        self.tableView.reloadData()
    }
}

extension OrganizationControlView: QRScannerCodeDelegate {

    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {

        self.presenter.handleScanResult(result, at: self.currentIndex)
        self.dismiss(animated: true, completion: nil)
    }

    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }

    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
