//
//  CompanyCustomPacketView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import UBottomSheet

protocol ICompanyCustomPacketView: AnyObject {

    func updatePrice(_ price: Float)
}

final class CompanyCustomPacketView: BUContentViewController {

    // MARK: - Public variables

    var presenter: CompanyCustomPacketPresenter!
    var sheetCoordinator: UBottomSheetCoordinator?
    var sheetCoordinatorDataSource: UBottomSheetCoordinatorDataSource?

    // MARK: - UI variabes

    private var tasksCountSetter: BUAmountSetter!
    private var benefitsCountSetter: BUAmountSetter!
    private var doneButton: UIButton!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.sheetCoordinator?.startTracking(item: self)
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.tasksCountSetter = BUAmountSetter(initValue: 0, minValue: 0, maxValue: 1000, stepValue: 10)
        self.tasksCountSetter.title = "ui_tasks_count_title"
        self.tasksCountSetter.onValueChanged = { [weak self] value in

            self?.presenter.setupTasksCount(value)
        }

        self.benefitsCountSetter = BUAmountSetter(initValue: 0, minValue: 0, maxValue: 1000, stepValue: 10)
        self.benefitsCountSetter.title = "ui_benefits_count_title"
        self.benefitsCountSetter.onValueChanged = { [weak self] value in

            self?.presenter.setupBenefitsCount(value)
        }

        self.doneButton = self.configureDoneButton()

        self.view.addSubview(self.tasksCountSetter)
        self.view.addSubview(self.benefitsCountSetter)
        self.view.addSubview(self.doneButton)

        self.tasksCountSetter.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }

        self.benefitsCountSetter.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(self.tasksCountSetter.snp.bottom).offset(10)
        }

        self.doneButton.snp.makeConstraints { make in
            make.top.equalTo(self.benefitsCountSetter.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.7)
            make.height.equalTo(50)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    // MARK: - Configure

    private func configureDoneButton() -> UIButton {

        let button = UIButton(type: .system)

        button.theme_backgroundColor = Colors.greenColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.avenirHeavy(20)
        button.theme_setTitleColor(Colors.backgroundColor, forState: .normal)

        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

        return button
    }

    // MARK: - Selectors

    @objc private func doneTapped() {

        self.presenter.handleDoneButtonTap()
    }
}

// MARK: - ICompanyCustomPacketView

extension CompanyCustomPacketView: ICompanyCustomPacketView {

    func updatePrice(_ price: Float) {

        self.doneButton.setTitle("\(price)$", for: .normal)
    }
}

// MARK: - Draggable

extension CompanyCustomPacketView: Draggable {

    func draggableView() -> UIScrollView? {

        return nil
    }
}
