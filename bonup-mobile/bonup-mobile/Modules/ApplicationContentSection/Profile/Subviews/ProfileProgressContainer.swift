//
//  ProfileProgressContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol ProfileProgressContainerDataSource: AnyObject {
    func profileProgressContainer(
        _ container: ProfileProgressContainer,
        progressFor type: ProfileProgressContainer.ProgressType) -> CGFloat
}

final class ProfileProgressContainer: UIView {

    enum ProgressType {
        case lastWeek, lastMonth, all, today
    }

    // MARK: - Public variables

    weak var dataSource: ProfileProgressContainerDataSource!

    // MARK: - Private variables

    private var lastWeekProgressView: UICircularProgressRing!
    private var lastMonthProgressView: UICircularProgressRing!
    private var todayProgressView: UICircularProgressRing!
    private var allProgressView: UICircularProgressRing!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func reloadData() {
        let all = self.dataSource.profileProgressContainer(self, progressFor: .all)
        let today = self.dataSource.profileProgressContainer(self, progressFor: .today)
        let lastWeek = self.dataSource.profileProgressContainer(self, progressFor: .lastWeek)
        let lastMonth = self.dataSource.profileProgressContainer(self, progressFor: .lastMonth)

        self.allProgressView.startProgress(
            to: all,
            duration: 0.3,
            completion: {
                self.todayProgressView.startProgress(
                    to: today,
                    duration: 0.3,
                    completion: {
                        self.lastWeekProgressView.startProgress(
                            to: lastWeek,
                            duration: 0.3,
                            completion: {
                                self.lastMonthProgressView.startProgress(
                                    to: lastMonth,
                                    duration: 0.3,
                                    completion: nil
                                )
                            }
                        )
                    }
                )
            }
        )
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        let allContainer = self.conifigureProgressContainer(for: .all)
        let lastMonthContainer = self.conifigureProgressContainer(for: .lastMonth)
        let lastWeekContainer = self.conifigureProgressContainer(for: .lastWeek)
        let todayContainer = self.conifigureProgressContainer(for: .today)

        self.addSubview(allContainer)
        self.addSubview(lastMonthContainer)
        self.addSubview(lastWeekContainer)
        self.addSubview(todayContainer)

        allContainer.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        todayContainer.snp.makeConstraints { make in
            make.leading.equalTo(allContainer.snp.trailing).offset(10.0)
            make.top.trailing.equalToSuperview()
        }

        lastWeekContainer.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(allContainer.snp.bottom).offset(10.0)
        }

        lastMonthContainer.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(todayContainer.snp.bottom).offset(10.0)
        }
    }

    // MARK: - Conifgure subviews

    private func conifigureProgressContainer(for type: ProgressType) -> UIView {
        let containerView = UIView()

        let progressViewSize = 120;

        switch type {
        case .all:
            let titleLabel = self.configureTitleLabel(with: "ui_all_period_title".localized)
            self.allProgressView = self.configureProgressView(with: 100.0, tint: .orange, pattern: 1.0)

            containerView.addSubview(titleLabel)
            containerView.addSubview(self.allProgressView)

            titleLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }

            self.allProgressView.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.width.equalTo(progressViewSize)
                make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
                make.width.equalTo(self.allProgressView.snp.height)
            }
        case .lastWeek:
            let titleLabel = self.configureTitleLabel(with: "ui_last_week_title".localized)
            self.lastWeekProgressView = self.configureProgressView(with: 100.0, tint: .green, pattern: 2.0)

            containerView.addSubview(titleLabel)
            containerView.addSubview(self.lastWeekProgressView)

            titleLabel.snp.makeConstraints { make in
                make.bottom.centerX.equalToSuperview()
            }

            self.lastWeekProgressView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.width.equalTo(progressViewSize)
                make.bottom.equalTo(titleLabel.snp.top).offset(-10.0)
                make.width.equalTo(self.lastWeekProgressView.snp.height)
            }
        case .lastMonth:
            let titleLabel = self.configureTitleLabel(with: "ui_last_month_title".localized)
            self.lastMonthProgressView = self.configureProgressView(with: 100.0, tint: .red , pattern: 3.0)

            containerView.addSubview(titleLabel)
            containerView.addSubview(self.lastMonthProgressView)

            titleLabel.snp.makeConstraints { make in
                make.bottom.centerX.equalToSuperview()
            }

            self.lastMonthProgressView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.width.equalTo(progressViewSize)
                make.bottom.equalTo(titleLabel.snp.top).offset(-10.0)
                make.width.equalTo(self.lastMonthProgressView.snp.height)
            }
        case .today:
            let titleLabel = self.configureTitleLabel(with: "ui_today_title".localized)
            self.todayProgressView = self.configureProgressView(with: 100.0, tint: .brown, pattern: 4.0)

            containerView.addSubview(titleLabel)
            containerView.addSubview(self.todayProgressView)

            titleLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }

            self.todayProgressView.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.width.equalTo(progressViewSize)
                make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
                make.width.equalTo(self.todayProgressView.snp.height)
            }
        }

        return containerView
    }

    private func configureProgressView(with maxValue: CGFloat,
                                       tint color: UIColor,
                                       pattern: CGFloat) -> UICircularProgressRing {
        let progressRing = UICircularProgressRing()

        progressRing.maxValue = maxValue
        progressRing.style = .dashed(pattern: [pattern, 1.0])
        progressRing.tintColor = color
        progressRing.innerRingColor = color.withAlphaComponent(0.3)

        return progressRing
    }

    private func configureTitleLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.text = text
        label.textColor = UIColor.purpleLite.withAlphaComponent(0.5)
        label.font = UIFont.avenirHeavy(15.0)

        return label
    }
}
