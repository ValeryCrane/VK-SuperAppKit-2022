//
//  InfoInteractor.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

protocol InfoBusinessLogic {
    func fetchInfo(startIndex: Int)
    func fetchInfo(endIndex: Int)
}

class InfoInteractor {
    var presenter: InfoPresentationLogic!
}

// MARK: - InfoBusinessLogic implementation.
extension InfoInteractor: InfoBusinessLogic {
    func fetchInfo(startIndex: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchResult = InfoDataSource.getInfoBatch(
                startIndex: startIndex,
                batchSize: InfoConstants.defaultBatchSize
            )
            guard let fetchResult = fetchResult else { return }
            
            self?.presenter.presentInfoAtBack(fetchResult)
        }
    }
    
    func fetchInfo(endIndex: Int) {
        guard endIndex != 0 else { return }
        var startIndex = endIndex - InfoConstants.defaultBatchSize
        var batchSize = InfoConstants.defaultBatchSize
        if startIndex < 0 {
            batchSize += startIndex
            startIndex = 0
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchResult = InfoDataSource.getInfoBatch(
                startIndex: startIndex,
                batchSize: batchSize
            )
            guard let fetchResult = fetchResult else { return }
            
            self?.presenter.presentInfoAtFront(fetchResult)
        }
    }
}
