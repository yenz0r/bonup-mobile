//
//  TaskDescriptionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITaskDescriptionRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: TaskDescriptionRouter.TaskDescriptionRouterScenario)
}

final class TaskDescriptionRouter {
    
    enum TaskDescriptionRouterScenario {
        
        case showCompanyDetails(company: CompanyEntity)
    }

    // MARK: - Private variables
    
    private var view: TaskDescriptionView?
    private var parentController: UIViewController?

    // MARK: - Init
    
    init(view: TaskDescriptionView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ITaskDescriptionRouter implementation

extension TaskDescriptionRouter: ITaskDescriptionRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController?.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController?.navigationController?.popViewController(animated: true)
        self.view = nil

        completion?()
    }

    func show(_ scenario: TaskDescriptionRouterScenario) {
        
        guard let view = self.view else { return }
        
        switch scenario {
        
        case .showCompanyDetails(company: let company):
            
            let dependency = AddCompanyDependency(
                parentNavigationController: view.navigationController!,
                initCompany: company,
                mode: .read,
                companyPacket: nil)
            let builder = AddCompanyBuilder()
            let router = builder.build(dependency)
            
            router.start(nil)
        }
    }
}

