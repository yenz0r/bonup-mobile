//
//  ProfileActionsChartsContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 5.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import Charts

protocol ProfileActionsChartsContainerDataSource: AnyObject {
    
    func actionsCharts(_ charts: ProfileActionsChartsContainer,
                       needsDataFor category: ProfileActionsChartsContainer.Category) -> PieChartData
}

final class ProfileActionsChartsContainer: UIView {
    
    enum Category: Int, CaseIterable {
        
        case tasks = 0, coupons
        
        var title: String {
            
            switch self {
            
            case .tasks:
                return "ui_tasks_title"
                
            case .coupons:
                return "ui_coupons_title"
            }
        }
    }
    
    typealias CategorySelectionCompletion = ((Category) -> Void)
    
    // MARK: - Data variables
    
    private var selectedCategory: Category
    private var onCategorySelection: CategorySelectionCompletion?
    
    // MARK: - UI variables
    
    private var pieChart: PieChartView!
    private var segmentControl: BUSegmentedControl!
    
    // MARK: - Public variables
    
    weak var dataSource: ProfileActionsChartsContainerDataSource?
    
    // MARK: - Init
    
    init(selectedCategory: Category, onCategorySelection: CategorySelectionCompletion?) {
        
        self.selectedCategory = selectedCategory
        self.onCategorySelection = onCategorySelection
        
        super.init(frame: .zero)
    
        self.setupSubviews()
        self.setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func reloadData() {
        
        guard let source = self.dataSource else { return }
        
        self.pieChart.data = source.actionsCharts(self, needsDataFor: self.selectedCategory)
        
        self.pieChart.animate(xAxisDuration: 1.4,
                              easingOption: .easeOutBack)
        self.pieChart.spin(duration: 1.5,
                           fromAngle: self.pieChart.rotationAngle,
                           toAngle: self.pieChart.rotationAngle + 360.0,
                           easingOption: .easeInBounce)
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.backgroundColor = .clear
    }
    
    private func setupSubviews() {
       
        self.segmentControl = self.configureSegmentControl()
        self.pieChart = self.configureChartView()
        
        self.addSubview(self.pieChart)
        self.pieChart.addSubview(self.segmentControl)
        
        self.segmentControl.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
        
        self.pieChart.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    private func configureChartView() -> PieChartView {
        
        let chartView = PieChartView()
        
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        chartView.legend.enabled = false
        
        return chartView
    }
    
    private func configureSegmentControl() -> BUSegmentedControl {
        
        let control = BUSegmentedControl(nonlocalizedItems: Category.allCases.map({ $0.title }))
        
        control.addTarget(self, action: #selector(segmentControlChange(_:)), for: .touchUpInside)
        
        return control
    }
    
    // MARK: - Selectors
    
    @objc private func segmentControlChange(_ sender: UISegmentedControl) {
        
        self.selectedCategory = Category.allCases[sender.selectedSegmentIndex]
        self.onCategorySelection?(self.selectedCategory)
    }
}