//
//  InfoInteractor.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

protocol InfoBusinessLogic {
    func fetchInfo(startIndex: Int)             // Fetches info at back of the list.
    func fetchInfo(endIndex: Int)               // Fetches info at front of the list.
    func fetchSearchedInfo(startIndex: String)  // Fetches info at given index.
}

class InfoInteractor {
    var presenter: InfoPresentationLogic!
}

// MARK: - InfoBusinessLogic implementation.
extension InfoInteractor: InfoBusinessLogic {
    func fetchInfo(startIndex: Int) {
        InfoDataSource.getInfoBatch(startIndex: startIndex,
                                    batchSize: InfoConstants.defaultBatchSize) { [weak self] fetchResult in
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
        InfoDataSource.getInfoBatch(startIndex: startIndex,
                                    batchSize: batchSize) { [weak self] fetchResult in
            guard let fetchResult = fetchResult else { return }
            self?.presenter.presentInfoAtFront(fetchResult)
        }
    }
    
    func fetchSearchedInfo(startIndex: String) {
        guard let startIndex = Int(startIndex) else { return }
        var batchSize = InfoConstants.defaultBatchSize * 2
        var fetchStartIndex = startIndex - InfoConstants.defaultBatchSize
        if fetchStartIndex < 0 {
            batchSize += fetchStartIndex
            fetchStartIndex = 0
        }
        InfoDataSource.getInfoBatch(startIndex: fetchStartIndex,
                                    batchSize: batchSize) { [weak self] fetchResult in
            guard let fetchResult = fetchResult else { return }
            self?.presenter.presentSearchedInfo(fetchResult, startIndex: batchSize - InfoConstants.defaultBatchSize)
        }
    }
}
