//
//  FMPhotoPickerViewController+Config.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import FMPhotoPicker

extension FMPhotoPickerViewController {

    static var defaultConfig: FMPhotoPickerConfig {

        var config = FMPhotoPickerConfig()
        config.mediaTypes = [.image]
        config.selectMode = .single
        config.maxImage = 1
        config.maxVideo = 0
        config.useCropFirst = true
        config.strings = [

            "picker_button_cancel":                     "ui_cancel".localized,
            "picker_button_select_done":                "ui_done_title".localized,
            "picker_warning_over_image_select_format":  "",
            "picker_warning_over_video_select_format":  "",

            "present_title_photo_created_date_format":  "yyyy/M/d",
            "present_button_back":                      "",
            "present_button_edit_image":                "ui_edit".localized,

            "editor_button_cancel":                     "ui_cancel".localized,
            "editor_button_done":                       "ui_done_title".localized,
            "editor_menu_filter":                       "ui_filter".localized,
            "editor_menu_crop":                         "ui_crop".localized,
            "editor_menu_crop_button_reset":            "ui_reset".localized,
            "editor_menu_crop_button_rotate":           "ui_rotate".localized,

            "editor_crop_ratio4x3":                     "4:3",
            "editor_crop_ratio16x9":                    "16:9",
            "editor_crop_ratio9x16":                    "9x16",
            "editor_crop_ratioCustom":                  "ui_custom".localized,
            "editor_crop_ratioOrigin":                  "ui_origin".localized,
            "editor_crop_ratioSquare":                  "ui_square".localized,

            "permission_dialog_title":                  "ui_select_photo_title".localized,
            "permission_dialog_message":                "ui_select_photo_description".localized,
            "permission_button_ok":                     "ui_done_title".localized,
            "permission_button_cancel":                 "ui_cancel".localized
        ]

        return config
    }
}
