//
//  NorthAmericaModel.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation
import TFLiteSwift_Vision

final class NorthAmericaModel: ModelInfoStorable {
    private enum Resource {
        static let modelName = "lite-model_on_device_vision_classifier_landmarks_classifier_north_america_V1_1"
        static let labelFileName = "landmarks_classifier_north_america_V1_label_map"
    }
    
    private enum Constant {
        static let inputWidth: Int = 321
        static let inputHeight: Int = 321
    }
    
    private lazy var labels: [String] = {
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
    
    
    private lazy var visionInterpreter: TFLiteVisionInterpreter = {
        let interpreterOptions = TFLiteVisionInterpreter.Options(
            modelName: Resource.modelName,
            inputWidth: Constant.inputWidth,
            inputHeight: Constant.inputHeight,
            normalization: .scaledNormalization
        )
        return TFLiteVisionInterpreter(options: interpreterOptions)
    }()
    
    func process(input: TFLiteVisionInput) -> String {
        guard let inputData: Data = visionInterpreter.preprocess(with: input)
        else { fatalError("Cannot preprcess") }
        
        guard let outputs: TFLiteFlatArray<Float32> = visionInterpreter.inference(with: inputData)?.first
        else { fatalError("Cannot inference") }
        
        let predictedIndex: Int = Int(outputs.argmax())
        
        let predictedLabel = self.labels[predictedIndex]
        
        return predictedLabel
    }
}

// https://tfhub.dev/google/lite-model/on_device_vision/classifier/landmarks_classifier_north_america_V1/1
