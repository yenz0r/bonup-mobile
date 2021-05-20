//
//  CompanyActionsListView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

protocol ICompanyActionsListView: AnyObject {
    
    func reloadData()
}

final class CompanyActionsListView: BUContentViewController {
    
    // MARK: - UI variables
    
    private var tableView: UITableView!
    
    // MARK: - Data variables
    
    var presenter: CompanyActionsListPresenter!
    
    // MARK: - Life cycle
    
    override func loadView() {
        
        self.view = UIView()
        
        self.setupSubviews()
        self.setupAppearance()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.presenter.handleViewDidLoad()
        
        self.tableView.reloadEmptyDataSet()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.view.theme_backgroundColor = Colors.backgroundColor
    }
    
    private func setupSubviews() {
       
        self.tableView = self.configureTableView()
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Localization

    override func setupLocalizableContent() {
        
        self.navigationItem.title = self.presenter.controllerTitle.localized
    }
    
    // MARK: - Theme
    
    override func setupThemeChangableContent() { }
    
    // MARK: - Configure
    
    private func configureTableView() -> UITableView {
        
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 40)
        
        tableView.register(CompanyActionsListCell.self,
                           forCellReuseIdentifier: CompanyActionsListCell.reuseId)
        
        return tableView
    }
}

// MARK: - UITableViewDelegate

extension CompanyActionsListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.presenter.handleActionSelection(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension CompanyActionsListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.presenter.numberOfActions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyActionsListCell.reuseId,
                                                 for: indexPath) as! CompanyActionsListCell
        
        cell.setup(title: self.presenter.actionTitle(at: indexPath.row),
                   descriptionInfo: self.presenter.actionDescription(at: indexPath.row),
                   dateInfo: self.presenter.actionDateInfo(at: indexPath.row),
                   dateInfoColor: self.presenter.actionDateInfoColor(at: indexPath.row))
        
        return cell
    }
}

// MARK: - EmptyDataSetSource

extension CompanyActionsListView: EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: self.presenter.emtpyDataSetTitle.localized,
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

// MARK: - ICompanyStatisticsView

extension CompanyActionsListView: ICompanyActionsListView {
    
    func reloadData() {
        
        self.tableView.reloadData()
    }
}
