//
//  TimerManager.swift
//  bonup-mobile
//
//  Created by yenz0redd on 21.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITimerManager {
    func start(onProgress:((_ currentValue: UInt) -> Void)?,
               onFinish: (() -> Void)?)
    func stopNow(_ completion: ((_ currentValue: UInt) -> Void)?)
}

final class TimerManager {

    // NOTE: - This class must be always created like a property in class
    // with strong link on it

    enum Direction {
        case up, down
    }

    // MARK: - Private variables

    private let initialTime: UInt
    private let interval: UInt
    private let finishTime: UInt
    private let direction: Direction

    private var currentValue: UInt
    private var currentTimer: Timer?

    // MARK: - Initialization

    init(initTime: UInt,
         interval: UInt,
         finishTime: UInt,
         direction: TimerManager.Direction) {
        self.interval = interval
        self.initialTime = initTime
        self.finishTime = finishTime
        self.currentValue = initialTime
        self.direction = direction
    }
}

// MARK: - ITimerManager implementation

extension TimerManager: ITimerManager {
    func start(onProgress:((_ currentValue: UInt) -> Void)?,
               onFinish: (() -> Void)?) {
        let timer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(self.interval),
            repeats: true,
            block: { [weak self] _ in

                guard let strongSelf = self else { return }

                var isDone = false
                switch strongSelf.direction {
                case .up:
                    strongSelf.currentValue += strongSelf.interval
                    isDone = strongSelf.currentValue >= strongSelf.finishTime
                case .down:
                    strongSelf.currentValue -= strongSelf.interval
                    isDone = strongSelf.currentValue <= strongSelf.finishTime
                }

                onProgress?(strongSelf.currentValue)

                if isDone {
                    strongSelf.reloadTimerManager()
                    onFinish?()
                }
            }
        )
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.2

        self.currentTimer = timer
    }

    func stopNow(_ completion: ((_ currentValue: UInt) -> Void)?) {
        completion?(self.currentValue)
        self.reloadTimerManager()
    }

    private func reloadTimerManager() {
        self.currentTimer?.invalidate()
        self.currentTimer = nil
        self.currentValue = self.initialTime
    }
}
