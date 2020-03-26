//
//  AuthVerificationPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IAuthVerificationPresenter {
    func handleSendButtonTap(code: String)
    func handleResendButtonTap()
    func viewDidAppear()
}

final class AuthVerificationPresenter {

    // MARK: - Private variables

    private weak var view: IAuthVerificationView?
    private let interactor: IAuthVerificationInteractor
    private let router: IAuthVerificationRouter

    private var restTime: UInt = 0
    private let timeForCode: UInt = 180

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
    func handleSendButtonTap(code: String) {
        self.timerManager.stopNow { [weak self] restTime in
            self?.restTime = restTime
        }

        self.interactor.verify(code: code) { [weak self] isSuccess in

            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                if isSuccess {
                    strongSelf.router.show(.openApplication)
                } else {
                    strongSelf.router.show(.errorAlert)
                    strongSelf.startTimer(with: strongSelf.restTime)
                }
            }
        }
    }

    func handleResendButtonTap() {
        self.timerManager.stopNow(nil)
        self.startTimer(with: self.timeForCode)
    }

    func viewDidAppear() {
        self.startTimer(with: self.timeForCode)
    }
}

// MARK: - Helpers

extension AuthVerificationPresenter {
    private func startTimer(with initTime: UInt) {
        self.timerManager = TimerManager(
            initTime: initTime,
            interval: 1,
            finishTime: 0,
            direction: .down
        )

        self.timerManager.start(onProgress: { currentValue in
            self.view?.displayTimerText(
                "\(self.timeString(Int(currentValue)))",
                currentValue > 10 ? .white80 : .red
            )
        }, onFinish: {
            self.view?.displayTimerText("ui_time_is_off".localized, .red)
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
