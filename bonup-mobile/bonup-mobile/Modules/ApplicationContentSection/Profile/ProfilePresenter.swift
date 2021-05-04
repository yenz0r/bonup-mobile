//
//  ProfilePresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Charts

protocol IProfilePresenter: AnyObject {

    func handleInfoButtonTapped()
    func viewWillAppear()

    var name: String { get }
    var email: String { get }
    var organization: String { get }

    var doneTasks: String { get }
    var restBalls: String { get }
    var allSpendBalls: String { get }

    var donePercent: CGFloat { get }
    var activatedCouponsPercent: CGFloat { get }
    var spentBallsPercent: CGFloat { get }
    var ballsPercent: CGFloat { get }

    func archiveTitle(for index: Int) -> String
    func archiveDescription(for index: Int) -> String
    func archiveState(for index: Int) -> Bool
    func archivesCount() -> Int
    
    func actionsChartData(for category: ProfileActionsChartsContainer.Category) -> PieChartData
}

final class ProfilePresenter {
    private weak var view: IProfileView?
    private let interactor: IProfileInteractor
    private let router: IProfileRouter

    private var responseEntiry: ProfileResponseDetailsEntity?

    init(view: IProfileView?, interactor: IProfileInteractor, router: IProfileRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension ProfilePresenter: IProfilePresenter {

    var name: String {
        return self.responseEntiry?.name ?? "-"
    }

    var email: String {
        return self.responseEntiry?.email ?? "-"
    }

    var organization: String {
        return self.responseEntiry?.organizationName ?? "-"
    }

    var doneTasks: String {
        return "\(self.responseEntiry?.tasksNumber ?? 0)"
    }

    var restBalls: String {
        return "\(self.responseEntiry?.balls ?? 0)"
    }

    var allSpendBalls: String {
        return "\(self.responseEntiry?.spentBalls ?? 0)"
    }

    var donePercent: CGFloat {
        return CGFloat(self.responseEntiry?.donePercent ?? 0)
    }

    var activatedCouponsPercent: CGFloat {
        return CGFloat(self.responseEntiry?.couponsPercent ?? 0)
    }

    var spentBallsPercent: CGFloat {
        return CGFloat(self.responseEntiry?.spentBalls ?? 0)
    }

    var ballsPercent: CGFloat {
        return CGFloat(self.responseEntiry?.ballsPercent ?? 0)
    }

    func archiveTitle(for index: Int) -> String {

        guard let response = self.responseEntiry else { return "" }

        return response.goals[index].name
    }

    func archiveDescription(for index: Int) -> String {

        guard let response = self.responseEntiry else { return "" }

        return response.goals[index].description
    }

    func archiveState(for index: Int) -> Bool {

        guard let response = self.responseEntiry else { return false }

        return response.goals[index].flag
    }

    func archivesCount() -> Int {

        guard let response = self.responseEntiry else { return 0 }

        return response.goals.count
    }


    func handleInfoButtonTapped() {

        self.router.show(.infoAlert(nil))
    }

    func viewWillAppear() {

        self.interactor.getUserInfo(
            success: { [weak self] response in

                self?.responseEntiry = response
                self?.view?.reloadData()
            },
            failure: { [weak self] message in

                self?.router.show(.infoAlert(message))
            }
        )
    }
    
    func actionsChartData(for category: ProfileActionsChartsContainer.Category) -> PieChartData {
        
        let entries = (0..<5).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: 0.4,
                                     label: "Test")
        }
        
        let set = PieChartDataSet(entries: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        return data
    }
}
