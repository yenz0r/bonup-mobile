//
//  Colors.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import SwiftTheme

struct Colors {

    static let backgroundColor: ThemeColorPicker = ["#fff", "#3a3647"]

    static let defaultTextColor: ThemeColorPicker = ["#000", "#FFF"]
    static let grayTextColor: ThemeColorPicker = ["#6a697fff", "#6a697fff"]

    static let redColor: ThemeColorPicker = ["#cc1f28", "#cc1f28"]
    static let greenColor: ThemeColorPicker = ["#03912bff", "#186e30ff"]

    static let tabBarBackgroudColor: ThemeColorPicker = ["#fff", "#3a3040ff"]
    static let tabBarTextColor: ThemeColorPicker = ["#fff", "#a5a2d0"]
    static let tabBarIconColor: ThemeColorPicker = ["#000", "#fff"]

    static let navBarTextColor: ThemeColorPicker = ["#000", "#fff"]
    static let navBarIconColor: ThemeColorPicker = ["#cf0a17", "#6a697fff"]


    static let settingsIconsColor: ThemeColorPicker = ["#000", "#6a697fff"]

    static let keyboardAppearance = ThemeKeyboardAppearancePicker(styles: .light, .dark)
}
