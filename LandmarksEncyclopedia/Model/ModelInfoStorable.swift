//
//  ModelInfoStorable.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Foundation

protocol ModelInfoStorable {
    var name: String { get }
    var labels: [String] { get }
    var inputWidth: Int { get }
    var inputHeight: Int { get }
}
