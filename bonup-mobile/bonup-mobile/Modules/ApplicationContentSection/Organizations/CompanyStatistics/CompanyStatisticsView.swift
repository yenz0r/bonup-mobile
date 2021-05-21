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
    
    func reloadChart(data: LineChartData, labels: [String])
}

final class CompanyStatisticsView: BUContentViewController {
    
    // MARK: - UI variables
    
    private var infoTypeSegmentedControl: BUSegmentedControl!
    private var periodContianer: CompanyStatisticsPeriodView!
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.presenter.handleViewDidLoad()
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
       
        self.infoTypeSegmentedControl = self.configureInfoTypeSegmentControl()
        self.periodContianer = self.configurePeriodContainer()
        self.chartView = self.configureChartsView()
        self.categoriesContainer = self.configureCategoriesContainer()
        
        self.view.addSubview(self.infoTypeSegmentedControl)
        self.view.addSubview(self.periodContianer)
        self.view.addSubview(self.chartView)
        self.view.addSubview(self.categoriesContainer)
        
        self.infoTypeSegmentedControl.snp.makeConstraints { make in
            
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        self.periodContianer.snp.makeConstraints { make in
            
            make.top.equalTo(self.infoTypeSegmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        self.categoriesContainer.snp.makeConstraints { make in
            
            make.trailing.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-40)
        }
        
        self.chartView.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.periodContianer.snp.bottom).offset(20)
            make.bottom.equalTo(self.categoriesContainer.snp.top).offset(-20)
        }
    }
    
    private func setupNavigationBar() {
        
        self.loc_title = "ui_company_statistics_title"
        
        let navigationItem = UIBarButtonItem(barButtonSystemItem: .action,
                                             target: self,
                                             action: #selector(shareTapped))
        
        navigationItem.theme_tintColor = Colors.navBarIconColor
        
        self.navigationItem.rightBarButtonItem = navigationItem
    }
    
    // MARK: - Configure
    
    private func configurePeriodContainer() -> CompanyStatisticsPeriodView {
        
        let container = CompanyStatisticsPeriodView(fromDate: self.presenter.periodFromDate,
                                                    toDate: self.presenter.periodToDate)
        
        container.onToDateChange = { [weak self] date in
            
            self?.presenter.periodToDate = date
        }
        
        container.onFromDateChange = { [weak self] date in
            
            self?.presenter.periodFromDate = date
        }
        
        return container
    }
    
    private func configureInfoTypeSegmentControl() -> BUSegmentedControl {
        
        let segment = BUSegmentedControl(nonlocalizedItems: self.presenter.intoTypesNonLocTitles)
        
        segment.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
        
        if let index = self.presenter.selectedInfoTypeIndex {
            
            segment.selectedSegmentIndex = index
        }
        
        return segment
    }
    
    private func configureChartsView() -> LineChartView {
        
        let chart = LineChartView()
        
        chart.xAxis.labelRotationAngle = -90.0
        chart.xAxis.labelCount = 5
        chart.xAxis.granularity = 1
        chart.legend.enabled = false
        chart.delegate = self
        
        return chart
    }
    
    private func configureCategoriesContainer() -> SelectCategoriesContainer {
        
        let dataSource = SelectCategoriesDataSource(selectedCategories: self.presenter.selectedCategories,
                                                    selectionMode: .multiple)
        let container = SelectCategoriesContainer(delegate: self, dataSource: dataSource)

        return container
    }
    
    // MARK: - Selectors
    
    @objc private func segmentDidChange(_ sender: UISegmentedControl) {
        
        self.presenter.updateSelectedInfoType(at: sender.selectedSegmentIndex)
    }
    
    @objc private func shareTapped() {
        
        self.presenter.handleShareAction(image: self.chartView.toImage())
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension CompanyStatisticsView: SelectCategoriesContainerDelegate {
    
    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {
        
        self.presenter
            .updateSelectedCategories(ids: container
                                        .dataSource
                                        .selectedCategories
                                        .map { $0.rawValue })
    }
}

// MARK: - ChartViewDelegate

extension CompanyStatisticsView: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        self.presenter.handleChartItemSelection(at: Int(entry.x))
    }
}

// MARK: - ICompanyStatisticsView

extension CompanyStatisticsView: ICompanyStatisticsView {
    
    func reloadChart(data: LineChartData, labels: [String]) {
     
        self.chartView.data = data
        self.chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { index, _ in
            
            return labels[Int(index)]
        })
        self.chartView.animate(yAxisDuration: 0.7, easing: .none)
        self.chartView.animate(xAxisDuration: 1, easing: .none)
    }
}
