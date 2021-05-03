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

    func numberOfPeriods() -> Int
    func periodTitle(at index: Int) -> String
    func updateSelectedPeriod(at index: Int)
    func selectedPeriodIndex() -> Int
    
    func updateSelectedCategories(ids: [Int])
    
    func terminate()
    
    func handleShareAction(image: UIImage)
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
    
    func numberOfPeriods() -> Int {
        
        return self.interactor.periods.count
    }
    
    func periodTitle(at index: Int) -> String {
        
        return self.interactor.periods[index].title
    }
    
    func updateSelectedPeriod(at index: Int) {
        
        self.interactor.updateSelectedPeriod(at: index)
        
        self.view?.reloadChart(data: self.calculareDataSet())
    }
    
    func updateSelectedCategories(ids: [Int]) {
        
        self.interactor.selectedCategoriesId = ids
        
        self.view?.reloadChart(data: self.calculareDataSet())
    }
    
    func selectedPeriodIndex() -> Int {
        
        return self.interactor.periods.firstIndex(where: { $0.id == self.interactor.selectedPeriod.id }) ?? 0
    }
    
    func terminate() {
        
        self.router.stop(withPop: false, stopCompetion: nil)
    }
    
    func handleShareAction(image: UIImage) {
        
        self.router.show(.share(image))
    }
    
    // TEST!!!!!!!!
    private func calculareDataSet() -> LineChartData {
        
        let yVals1 = (0..<(self.interactor.selectedPeriod.id + 1) * 10).map { (i) -> ChartDataEntry in
            let mult: UInt32 = 50 / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let dataSet = LineChartDataSet(entries: yVals1, label: "ui_user_activity".localized)
        
        dataSet.fill = Fill.fillWithLinearGradient(self.interactor.selectedPeriod.gradientForChart, angle: 90.0)
        dataSet.drawFilledEnabled = true
        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        return LineChartData(dataSet: dataSet)
    }
}
