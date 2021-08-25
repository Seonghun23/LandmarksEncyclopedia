//
//  InputInferable.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation
import TFLiteSwift_Vision

protocol InputInferable {
    func process(input: TFLiteVisionInput) -> Inference
}

extension InputInferable {
    typealias Inference = (label: String, threshold: Float32)
}
