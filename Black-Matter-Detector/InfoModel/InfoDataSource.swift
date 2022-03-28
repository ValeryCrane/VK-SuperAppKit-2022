//
//  InfoDataSource.swift
//  Black-Matter-Detector
//
//  Created by Валерий Журавлев on 28.03.2022.
//

import Foundation

class InfoDataSource {
    // Creates randomly generated batch of information and waits for a couple of milliseconds.
    public static func getInfoBatch(startIndex: Int, batchSize: Int,
                                    completionHandler: @escaping ([InfoModel]?) -> Void) {
        var result: [InfoModel] = []
        for i in 0..<batchSize {
            result.append(InfoModel(id: startIndex + i,
                                    time: Date.now,
                                    value: Float.random(in: 0..<10)
                                   ))
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) {
            completionHandler(result)
        }
    }
    
    // So to make InfoDataSource a singleton.
    private init() { }
}
