//
//  InfoAssembly.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation
import UIKit

class InfoAssembly {
    static func assemble() -> UIViewController {
        let view = InfoViewController()
        let interactor = InfoInteractor()
        let presenter = InfoPresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        return view
    }
}
