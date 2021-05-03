//
//  CompanyStatisticsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import Charts

protocol ICompanyStatisticsView: AnyObject {
    
    func reloadChart(data: LineChartData)
}

final class CompanyStatisticsView: BUContentViewController {
    
    // MARK: - UI variables
    
    private var periodSegmentedControl: UISegmentedControl!
    private var chartView: LineChartView!
    private var categoriesContainer: SelectCategoriesContainer!
    
    // MARK: - Data variables
    
    var presenter: CompanyStatisticsPresenter!
    
    // MARK: - Life cycle
    
    override func loadView() {
        
        self.view = UIView()
        
        self.setupSubviews()
        self.setupAppearance()
        self.setupNavigationBar()
    }
    
    override func controllerDidTerminate() {
        
        super.controllerDidTerminate()
        
        self.presenter.terminate()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.view.theme_backgroundColor = Colors.backgroundColor
        self.chartView.theme_backgroundColor = Colors.backgroundColor
    }
    
    private func setupSubviews() {
       
        self.periodSegmentedControl = self.configurePeriodSegmentControl()
        self.chartView = self.configureChartsView()
        self.categoriesContainer = self.configureCategoriesContainer()
        
        self.view.addSubview(self.periodSegmentedControl)
        self.view.addSubview(self.chartView)
        self.view.addSubview(self.categoriesContainer)
        
        self.periodSegmentedControl.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        self.categoriesContainer.snp.makeConstraints { make in
            make.trailing.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-40)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.periodSegmentedControl.snp.bottom).offset(20)
            make.bottom.equalTo(self.categoriesContainer.snp.top).offset(-20)
        }
    }
    
    private func setupNavigationBar() {
        
        let navigationItem = UIBarButtonItem(barButtonSystemItem: .action,
                                             target: self,
                                             action: #selector(shareTapped))
        
        navigationItem.theme_tintColor = Colors.navBarIconColor
        
        self.navigationItem.rightBarButtonItem = navigationItem
    }
    
    // MARK: - Localization

    override func setupLocalizableContent() {

        self.navigationItem.title = "ui_company_statistics_title".localized

        let selectedIndex = self.presenter.selectedPeriodIndex()

        self.periodSegmentedControl.removeAllSegments()

        for index in 0..<self.presenter.numberOfPeriods() {

            self.periodSegmentedControl.insertSegment(withTitle: self.presenter.periodTitle(at: index).localized,
                                                      at: index,
                                                      animated: false)
        }

        self.periodSegmentedControl.selectedSegmentIndex = selectedIndex
        
        self.segmentDidChange(self.periodSegmentedControl)
    }
    
    // MARK: - Theme
    
    override func setupThemeChangableContent() { }
    
    // MARK: - Configure
    
    private func configurePeriodSegmentControl() -> UISegmentedControl {
        
        let segment = UISegmentedControl(items: [])
        
        segment.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
        
        return segment
    }
    
    private func configureChartsView() -> LineChartView {
        
        let chart = LineChartView()
        
        chart.xAxis.labelRotationAngle = -90.0
        
        return chart
    }
    
    private func configureCategoriesContainer() -> SelectCategoriesContainer {
        
        let dataSource = SelectCategoriesDataSource(isActiveByDefault: false)
        let container = SelectCategoriesContainer(delegate: self, dataSource: dataSource)

        return container
    }
    
    // MARK: - Selectors
    
    @objc private func segmentDidChange(_ sender: UISegmentedControl) {
        
        self.presenter.updateSelectedPeriod(at: sender.selectedSegmentIndex)
    }
    
    @objc private func shareTapped() {
        
        self.presenter.handleShareAction(image: self.chartView.toImage())
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension CompanyStatisticsView: SelectCategoriesContainerDelegate {
    
    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {
        
        self.presenter.updateSelectedCategories(ids: container.dataSource.selectedCategories.map { $0.rawValue })
    }
}

// MARK: - ICompanyStatisticsView

extension CompanyStatisticsView: ICompanyStatisticsView {
    
    func reloadChart(data: LineChartData) {
     
        self.chartView.data = data
        self.chartView.animate(yAxisDuration: 0.7, easing: .none)
        self.chartView.animate(xAxisDuration: 1, easing: .none)
    }
}
