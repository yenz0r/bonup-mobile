//
//  CompanyPacketView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyPacketView: AnyObject {

    func updateBlurState(active state: Bool)

    func reloadItem(at index: Int)
}

final class CompanyPacketView: BUContentViewController {

    // MARK: - Public variables

    var presenter: CompanyPacketPresenter!

    // MARK: - UI variabes

    private var tableView: UITableView!
    private var blurView: UIView!

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
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if (self.isFirstLayout) {

            self.blurView.setupBlur()
            self.isFirstLayout = false
        }
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
        self.blurView = UIView()
        self.blurView.backgroundColor = .clear
        self.blurView.alpha = 0
        self.blurView.isUserInteractionEnabled = false

        self.view.addSubview(self.tableView)
        self.view.addSubview(self.blurView)

        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.tableFooterView = UIView()

        tableView.register(CompanyPacketCell.self, forCellReuseIdentifier: CompanyPacketCell.reuseId)

        return tableView
    }

    // MARK: - Selectors

    @objc private func doneTapped() {

        self.presenter.handleDoneAction()
    }
}

// MARK: - UITableViewDelegate

extension CompanyPacketView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let prevSelected = self.presenter.selectedPacketIndex
        let currSelected = indexPath.row

        self.presenter.handlePacketSelection(at: currSelected)

        self.tableView.reloadRows(at: [IndexPath(row: prevSelected ?? 0, section: 0),
                                       IndexPath(row: currSelected, section: 0)], with: .automatic)
    }
}

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
        cell.isPacketSelected = (self.presenter.selectedPacketIndex ?? -1) == indexPath.row

        return cell
    }
}

// MARK: - ICompanyPacketView

extension CompanyPacketView: ICompanyPacketView {

    func updateBlurState(active state: Bool) {

        UIView.animate(withDuration: 0.3) {

            self.blurView.alpha = state ? 1 : 0
            self.blurView.isUserInteractionEnabled = state
        }
    }

    func reloadItem(at index: Int) {

        let indexPath = IndexPath(row: index, section: 0)

        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
