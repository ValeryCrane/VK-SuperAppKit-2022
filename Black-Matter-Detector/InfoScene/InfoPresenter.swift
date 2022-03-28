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

class InfoPresenter {
    public weak var view: InfoDisplayLogic!
    private var page: [PresentedInfoModel] = []
    
    private func presentInfo(_ info: [InfoModel]) -> [PresentedInfoModel] {
        return info.map { model in
            PresentedInfoModel(
                id: model.id,
                info: "time = \(model.time.ISO8601Format()), value = \(model.value)")
        }
    }
}

// MARK: - InfoPresentationLogic implementation.
extension InfoPresenter: InfoPresentationLogic {
    func presentInfoAtFront(_ info: [InfoModel]) {
        let presentedInfo = presentInfo(info)
        page.insert(contentsOf: presentedInfo, at: 0)
        if page.count > InfoConstants.defaultPageSize {
            page.removeLast(page.count - InfoConstants.defaultPageSize)
        }
        
        DispatchQueue.main.async { [weak self] in
            if let page = self?.page {
                self?.view.displayInfo(page)
            }
        }
    }
    
    func presentInfoAtBack(_ info: [InfoModel]) {
        let presentedInfo = presentInfo(info)
        page.append(contentsOf: presentedInfo)
        if page.count > InfoConstants.defaultPageSize {
            page.removeFirst(page.count - InfoConstants.defaultPageSize)
        }
        
        DispatchQueue.main.async { [weak self] in
            if let page = self?.page {
                self?.view.displayInfo(page)
            }
        }
    }
}
