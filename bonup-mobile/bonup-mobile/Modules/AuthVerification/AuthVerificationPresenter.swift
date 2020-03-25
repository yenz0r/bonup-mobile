//
//  AuthVerificationPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IAuthVerificationPresenter {
    func handleSendButtonTap(code: String?)
    func handleResendButtonTap()
    func viewDidAppear()
}

final class AuthVerificationPresenter {

    // MARK: - Private variables

    private weak var view: IAuthVerificationView?
    private let interactor: IAuthVerificationInteractor
    private let router: IAuthVerificationRouter

    // MARK: - Services

    private var timerManager: TimerManager!

    init(view: IAuthVerificationView?,
         interactor: IAuthVerificationInteractor,
         router: IAuthVerificationRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - INewPasswordPresenter implementation

extension AuthVerificationPresenter: IAuthVerificationPresenter {
    func handleSendButtonTap(code: String?) {
        self.timerManager.stopNow(nil)
        print(code ?? "empty code")
    }

    func handleResendButtonTap() {
        self.timerManager.stopNow(nil)
        self.startTimer()
    }

    func viewDidAppear() {
        self.startTimer()
    }
}

// MARK: - Helpers

extension AuthVerificationPresenter {
    private func startTimer() {
        self.timerManager = TimerManager(initTime: 180, interval: 1, finishTime: 0, direction: .down)

        self.timerManager.start(onProgress: { currentValue in
            self.view?.displayTimerText("\(self.timeString(Int(currentValue)))")
        }, onFinish: {
            self.view?.displayTimerText("ui_time_is_off".localized)
        })
    }

    private func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    private func timeString(_ timeSeconds: Int) -> String {
        let timeComponents = self.secondsToHoursMinutesSeconds(seconds: timeSeconds)

        let first = timeComponents.1 / 10 == 0 ? "0\(timeComponents.1)" : "\(timeComponents.1)"
        let second = timeComponents.2 / 10 == 0 ? "0\(timeComponents.2)" : "\(timeComponents.2)"

        return "\(first):\(second)"
    }
}
