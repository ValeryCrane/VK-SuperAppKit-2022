//
//  InfoPresenter.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

protocol InfoPresentationLogic {
    func presentInfoAtFront(_ info: [InfoModel])        // Presents info at front of the list.
    func presentInfoAtBack(_ info: [InfoModel])         // Presents info at back of the list.
    func presentSearchedInfo(_ info: [InfoModel], startIndex: Int)  // Presents info at given index.
}

class InfoPresenter {
    public weak var view: InfoDisplayLogic!
    private var page: [PresentedInfoModel] = []         // Current list
    
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
        let topCellRow = presentedInfo.count
        page.insert(contentsOf: presentedInfo, at: 0)
        if page.count > InfoConstants.defaultPageSize {
            page.removeLast(page.count - InfoConstants.defaultPageSize)
        }
        
        DispatchQueue.main.async { [weak self] in
            if let page = self?.page {
                self?.view.displayFrontInfo(page, topCellRow: topCellRow)
            }
        }
    }
    
    func presentInfoAtBack(_ info: [InfoModel]) {
        let presentedInfo = presentInfo(info)
        page.append(contentsOf: presentedInfo)
        if page.count > InfoConstants.defaultPageSize {
            page.removeFirst(page.count - InfoConstants.defaultPageSize)
        }
        let bottomCellRow = page.count - presentedInfo.count - 1
        DispatchQueue.main.async { [weak self] in
            if let page = self?.page {
                self?.view.displayBackInfo(page, bottomCellRow: bottomCellRow)
            }
        }
    }
    
    func presentSearchedInfo(_ info: [InfoModel], startIndex: Int) {
        let presentedInfo = presentInfo(info)
        page = presentedInfo
        DispatchQueue.main.async { [weak self] in
            if let page = self?.page {
                self?.view.displayFrontInfo(page, topCellRow: startIndex)
            }
        }
    }
}
