//
//  InfoPresenter.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

protocol InfoPresentationLogic {
    func presentInfoAtFront(_ info: [InfoModel])
    func presentInfoAtBack(_ info: [InfoModel])
}
