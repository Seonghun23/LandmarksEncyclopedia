//
//  AfricaModel.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation

class AfricaModel: ModelInfoStorable {
    private enum Resource {
        static let modelName = "lite-model_on_device_vision_classifier_landmarks_classifier_africa_V1_1"
        static let labelFileName = "landmarks_classifier_africa_V1_label_map"
    }
    
    let name: String = Resource.modelName
    
    private(set) lazy var labels: [String] = {
        guard let labelFilePath = Bundle.main.path(forResource: Resource.labelFileName, ofType: "csv") else {
            assertionFailure("Failure get labels::\(Resource.labelFileName)")
            return []
        }
        var labels: [String] = []
        do {
            labels = try String(contentsOfFile: labelFilePath)
                .split(separator: "\n")
                .compactMap { $0.split(separator: ",").last }
                .map(String.init)
            labels.removeFirst()
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        return labels
    }()
    
    let inputWidth: Int = 321
    let inputHeight: Int = 321
}

// https://tfhub.dev/google/lite-model/on_device_vision/classifier/landmarks_classifier_africa_V1/1
