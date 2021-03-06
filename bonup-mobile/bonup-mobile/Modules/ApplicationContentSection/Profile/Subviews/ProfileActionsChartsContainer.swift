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

protocol ProfileActionsChartsContainerDelegate: AnyObject {
    
    func actionsCharts(_ charts: ProfileActionsChartsContainer,
                       didTapAt index: Int,
                       in category: ProfileActionsChartsContainer.Category)
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
    private var titleLabel: UILabel!
    
    // MARK: - Public variables
    
    weak var dataSource: ProfileActionsChartsContainerDataSource?
    weak var delegate: ProfileActionsChartsContainerDelegate?
    
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
                           toAngle: self.pieChart.rotationAngle + 40.0,
                           easingOption: .easeOutSine)
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }
    
    private func setupSubviews() {
       
        self.titleLabel = self.configureTitleLabel()
        self.segmentControl = self.configureSegmentControl()
        self.pieChart = self.configureChartView()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.pieChart)
        self.pieChart.addSubview(self.segmentControl)
        
        self.titleLabel.snp.makeConstraints { make in
            
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(10)
        }
        
        self.segmentControl.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
        
        self.pieChart.snp.makeConstraints { make in
            
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Configure
    
    private func configureTitleLabel() -> UILabel {
        
        let label = BULabel()
        
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.font = .avenirRoman(15)
        label.loc_text = "ui_profile_statistics_label"
        
        return label
    }
    
    private func configureChartView() -> PieChartView {
        
        let chartView = PieChartView()
        
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 17, weight: .bold)
        chartView.legend.enabled = false
        chartView.backgroundColor = .clear
        chartView.delegate = self
        chartView.holeColor = .clear
        
        return chartView
    }
    
    private func configureSegmentControl() -> BUSegmentedControl {
        
        let control = BUSegmentedControl(nonlocalizedItems: Category.allCases.map({ $0.title }))
        
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentControlChange(_:)), for: .valueChanged)
        
        return control
    }
    
    // MARK: - Selectors
    
    @objc private func segmentControlChange(_ sender: UISegmentedControl) {
        
        self.selectedCategory = Category.allCases[sender.selectedSegmentIndex]
        self.onCategorySelection?(self.selectedCategory)
    }
}

// MARK: - ChartViewDelegate

extension ProfileActionsChartsContainer: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        guard let index = chartView.data?.dataSets.first?.entryIndex(entry: entry) else { return }
        
        self.delegate?.actionsCharts(self, didTapAt: index, in: self.selectedCategory)
    }
}
