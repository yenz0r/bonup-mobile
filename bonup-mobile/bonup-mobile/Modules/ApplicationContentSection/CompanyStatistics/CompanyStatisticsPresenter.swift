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
    
    func updateSelectedCategories(ids: [Int])
    func updateSelectedInfoType(at index: Int)
    
    func handleShareAction(image: UIImage)
    
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
        }
    }
    
    var periodFromDate: Date {
        
        get {
            
            return self.interactor.periodFromDate
        }
        
        set {
            
            self.interactor.periodFromDate = newValue
        }
    }
    
    var intoTypesNonLocTitles: [String] {
        
        return CompanyStatisticsInteractor.InfoType.allCases.map { $0.nonlocalizedTitle }
    }
    
    func updateSelectedInfoType(at index: Int) {
        
        self.interactor.selectedInfoType = CompanyStatisticsInteractor.InfoType.allCases[index]
        
        self.view?.reloadChart(data: self.calculareDataSet())
    }
    
    func updateSelectedCategories(ids: [Int]) {
        
        self.interactor.selectedCategoriesId = ids
        
        self.view?.reloadChart(data: self.calculareDataSet())
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
    
    // TEST!!!!!!!!
    private func calculareDataSet() -> LineChartData {
        
//        let yVals1 = (0..<(self.interactor.selectedPeriod.id + 1) * 10).map { (i) -> ChartDataEntry in
//            let mult: UInt32 = 50 / 2
//            let val = Double(arc4random_uniform(mult) + 50)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//
//        let dataSet = LineChartDataSet(entries: yVals1, label: "ui_user_activity".localized)
//
//        dataSet.fill = Fill.fillWithLinearGradient(self.interactor.selectedPeriod.gradientForChart, angle: 90.0)
//        dataSet.drawFilledEnabled = true
//        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        return LineChartData()
    }
}
