//
//  InfoDataSource.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

class InfoDataSource {
    public static func getInfoBatch(startIndex: Int, batchSize: Int) -> [InfoModel]? {
        var result: [InfoModel] = []
        for i in 0..<batchSize {
            result.append(InfoModel(id: startIndex + i,
                                    time: Date.now,
                                    value: Float.random(in: 0..<10)
                                   ))
        }
        return result
    }
    private init() { }
}
