//
//  ModelInfoStorable.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation
import TFLiteSwift_Vision

protocol ModelInfoStorable {
    func process(input: TFLiteVisionInput) -> String
}
