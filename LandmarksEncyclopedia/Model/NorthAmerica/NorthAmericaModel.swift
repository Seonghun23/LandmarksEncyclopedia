//
//  NorthAmericaModel.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation
import TFLiteSwift_Vision

final class NorthAmericaModel: InputInferable {
    private enum Resource {
        static let modelName = "lite-model_on_device_vision_classifier_landmarks_classifier_north_america_V1_1"
        static let labelFileName = "landmarks_classifier_north_america_V1_label_map"
    }
    
    private lazy var labels: [String] = {
        guard let labelFilePath = Bundle.main.path(forResource: Resource.labelFileName, ofType: "csv") else {
            assertionFailure("Failure get labels::\(Resource.labelFileName)")
            return []
        }
        var labels: [String] = []
        do {
            labels = try String(contentsOfFile: labelFilePath, encoding: .utf8)
                .components(separatedBy: "\n")
                .compactMap { $0.components(separatedBy: ",").last }
            labels.removeFirst()
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        return labels
    }()
    
    
    private lazy var visionInterpreter: TFLiteVisionInterpreter = {
        let interpreterOptions = TFLiteVisionInterpreter.Options(
            modelName: Resource.modelName,
            normalization: .meanStd(mean: [127.5], std: [127.5])
        )
        return TFLiteVisionInterpreter(options: interpreterOptions)
    }()
    
    func process(input: TFLiteVisionInput) -> Inference {
        guard let inputData = visionInterpreter.preprocess(with: input) else {
            fatalError("Failure to preprcess")
        }
        
        guard let outputs = visionInterpreter.inference(with: inputData)?.first else { fatalError("Failure to  inference")
        }
        
        let predictedIndex: Int = Int(outputs.argmax())
        
        let predictedLabel = self.labels[predictedIndex]
        let predictedThreshold = outputs.array[predictedIndex]
        
        return (label: predictedLabel, threshold: predictedThreshold)
    }
}

// https://tfhub.dev/google/lite-model/on_device_vision/classifier/landmarks_classifier_north_america_V1/1
