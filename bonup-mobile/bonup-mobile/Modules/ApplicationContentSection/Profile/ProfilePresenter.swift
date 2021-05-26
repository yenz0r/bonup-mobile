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
    func refreshData(completion: (() -> Void)?)

    var name: String { get }
    var email: String { get }
    var organization: String { get }
    var avatarUrl: URL? { get }

    var doneTasks: String { get }
    var restBalls: String { get }
    var allSpendBalls: String { get }

    func archiveTitle(for index: Int) -> String
    func archiveDescription(for index: Int) -> String
    func archiveState(for index: Int) -> Bool
    func archivesCount() -> Int
    
    func handleChartSelection(at index: Int, for category: ProfileActionsChartsContainer.Category)
    
    func actionsChartData(for category: ProfileActionsChartsContainer.Category) -> PieChartData
}

final class ProfilePresenter {
    
    // MARK: - Private variables
    
    private weak var view: IProfileView?
    private let interactor: IProfileInteractor
    private let router: IProfileRouter
    
    // MARK: - State variables
    
    private var isFirstRefresh = true

    // MARK: - Init
    
    init(view: IProfileView?, interactor: IProfileInteractor, router: IProfileRouter) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension ProfilePresenter: IProfilePresenter {

    var name: String { self.interactor.profileName ?? "..." }
    var email: String { self.interactor.profileEmail ?? "..." }
    var organization: String { self.interactor.profileOrganizationName ?? "..." }
    var avatarUrl: URL? { PhotosService.photoURL(for: self.interactor.profileAvatarId) }
    
    var doneTasks: String { "\(self.interactor.profileTasksCount ?? 0)" }
    var restBalls: String { "\(self.interactor.profileCurrentBallsCount ?? 0)" }
    var allSpendBalls: String { "\(self.interactor.profileSpentBallsCount ?? 0)" }

    func archiveTitle(for index: Int) -> String { return self.interactor.goals?[index].name ?? "" }
    func archiveDescription(for index: Int) -> String { return self.interactor.goals?[index].description ?? "" }
    func archiveState(for index: Int) -> Bool { return self.interactor.goals?[index].flag ?? false }
    func archivesCount() -> Int { self.interactor.goals?.count ?? 0 }

    func handleInfoButtonTapped() {

        self.router.show(.infoAlert(nil))
    }
    
    func handleChartSelection(at index: Int, for category: ProfileActionsChartsContainer.Category) {
        
        guard let stats = self.interactor.stats(for: category) else { return }
        
        let sortedStats = Array(stats).sorted(by: {$0.0.rawValue < $1.0.rawValue})
        let selectedStat = sortedStats[index]
        
        var contentType: CompanyActionsListDependency.ContentType
        
        switch category {
        
        case .tasks:
            contentType = .tasks
            
        case .coupons:
            contentType = .coupons
        }
        
        self.router.show(.showActionsList(actions: selectedStat.value,
                                          contentType: contentType))
    }

    func refreshData(completion: (() -> Void)?) {
        
        self.interactor.getUserInfo(
            withLoader: self.isFirstRefresh,
            success: { [weak self]  in
                
                DispatchQueue.main.async {
                
                    self?.view?.reloadData()
                    completion?()
                }
            },
            failure: { [weak self] message in

                DispatchQueue.main.async {
                 
                    self?.router.show(.infoAlert(message))
                    completion?()
                }
            }
        )
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }
    
    func actionsChartData(for category: ProfileActionsChartsContainer.Category) -> PieChartData {
        
        guard let stats = self.interactor.stats(for: category) else { return PieChartData() }
        
        let statsCount = stats.values.reduce(0, { result, actions in
             
            result + actions.count
        })
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        
        for (category, actions) in Array(stats).sorted(by: {$0.0.rawValue < $1.0.rawValue}) {
            
            entries.append(PieChartDataEntry(value: Double(actions.count) / Double(statsCount) * 100.0,
                                             label: category.title.localized))
            
            colors.append(category.color)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 10
        set.colors = colors
        set.selectionShift = 0
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.avenirRoman(14))
        data.setValueTextColor(.black)
        
        return data
    }
}
