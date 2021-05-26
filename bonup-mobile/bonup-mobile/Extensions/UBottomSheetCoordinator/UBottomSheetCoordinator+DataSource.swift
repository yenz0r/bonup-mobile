//
//  UBottomSheetCoordinator+DataSource.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import UBottomSheet

extension UBottomSheetCoordinator {

    func defaultDataSource(maxHeight: CGFloat) -> UBottomSheetCoordinatorDataSource {

        return DefaultBottomSheetCoordinatorDataSource(maxHeight: maxHeight)
    }
}

final class DefaultBottomSheetCoordinatorDataSource: UBottomSheetCoordinatorDataSource {

    // MARK: - Private variables

    private let maxHeight: CGFloat

    // MARK: - Init

    init(maxHeight: CGFloat) {

        self.maxHeight = maxHeight
    }

    // MARK: - Setup

    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {

        return [UIScreen.main.bounds.height - self.maxHeight]
    }

    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {

        return UIScreen.main.bounds.height - self.maxHeight
    }
}
