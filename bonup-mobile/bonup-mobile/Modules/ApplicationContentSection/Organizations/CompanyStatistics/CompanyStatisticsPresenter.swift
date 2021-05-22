//
//  CompanyStatisticsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import Charts

protocol ICompanyStatisticsPresenter: AnyObject {

    var periodToDate: Date { get set }
    var periodFromDate: Date { get set }
    
    var intoTypesNonLocTitles: [String] { get }
    var selectedInfoTypeIndex: Int? { get }
    var selectedCategories: [InterestCategories] { get set }
    
    func updateSelectedInfoType(at index: Int)
    
    func handleShareAction(image: UIImage)
    func handleViewDidLoad()
    
    func handleChartItemSelection(at index: Int)
    
    func terminate()
}

final class CompanyStatisticsPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyStatisticsView?
    private let interactor: ICompanyStatisticsInteractor
    private let router: ICompanyStatisticsRouter

    // MARK: - Init

    init(view: ICompanyStatisticsView?,
         interactor: ICompanyStatisticsInteractor,
         router: ICompanyStatisticsRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanyCustomPacketPresenter

extension CompanyStatisticsPresenter: ICompanyStatisticsPresenter {
    
    var periodToDate: Date {
        
        get {
            
            return self.interactor.periodToDate
        }
        
        set {
            
            self.interactor.periodToDate = newValue
            self.refreshChartsData()
        }
    }
    
    var periodFromDate: Date {
        
        get {
            
            return self.interactor.periodFromDate
        }
        
        set {
            
            self.interactor.periodFromDate = newValue
            self.refreshChartsData()
        }
    }
    
    var intoTypesNonLocTitles: [String] {
        
        return CompanyStatisticsInteractor.InfoType.allCases.map { $0.nonlocalizedTitle }
    }
    
    func handleChartItemSelection(at index: Int) {
        
        let contentType: CompanyActionsListDependency.ContentType
        
        switch self.interactor.selectedInfoType {
        
        case .tasks:
            contentType = .tasks
            
        case .coupons:
            contentType = .coupons
        }
        
        self.router.show(.showActionsList(self.interactor.filteredActions().actions[index], contentType))
    }
    
    func updateSelectedInfoType(at index: Int) {
        
        self.interactor.selectedInfoType = CompanyStatisticsInteractor.InfoType.allCases[index]
        self.refreshChartsData()
    }
    
    var selectedCategories: [InterestCategories] {
        
        get {
            
            self.interactor.selectedCategoriesId.map { .category(id: $0) }
        }
        
        set {
            
            self.interactor.selectedCategoriesId = newValue.map { $0.rawValue }
            self.refreshChartsData()
        }
    }
    
    func updateSelectedCategories(ids: [Int]) {
        
        self.interactor.selectedCategoriesId = ids
        self.refreshChartsData()
    }
    
    func terminate() {
        
        self.router.stop(withPop: false, stopCompetion: nil)
    }
    
    func handleShareAction(image: UIImage) {
        
        self.router.show(.share(image))
    }
    
    var selectedInfoTypeIndex: Int? {
        
        return CompanyStatisticsInteractor
            .InfoType
            .allCases
            .firstIndex(of: self.interactor.selectedInfoType)
    }
    
    func handleViewDidLoad() {
        
        self.interactor.loadStats(
            success: { [weak self] in
                
                DispatchQueue.main.async {
                 
                    self?.refreshChartsData()
                }
            },
            failure: { [weak self] text in
                
                DispatchQueue.main.async {
                    
                    self?.router.show(.showResultAlert(text))
                }
            }
        )
    }
    
    private func refreshChartsData() {
        
        let statsData = self.interactor.filteredActions()
        
        var entries = [ChartDataEntry]()
        
        for (index, actions) in statsData.actions.enumerated() {
            
            let usesCount = actions.reduce(0, { $0 + $1.triggeredCount })
            
            entries.append(ChartDataEntry(x: Double(index), y: Double(usesCount)))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "ui_user_activity".localized)
        dataSet.fill = Fill.fillWithLinearGradient(self.interactor.selectedInfoType.gradientForChart,
                                                   angle: 90.0)
        dataSet.drawFilledEnabled = true
        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        let data = LineChartData(dataSet: dataSet)
        
        self.view?.reloadChart(data: data, labels: statsData.labels)
    }
}
