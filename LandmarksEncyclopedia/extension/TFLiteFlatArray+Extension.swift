//
//  TFLiteFlatArray+Extension.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/25.
//

import Accelerate
import TFLiteSwift_Vision

extension TFLiteFlatArray where Element == Float32 {
    func argmax() -> UInt {
        let stride = vDSP_Stride(1)
        let n = vDSP_Length(array.count)
        var c: Float = .nan
        var i: vDSP_Length = 0
        vDSP_maxvi(array,
                   stride,
                   &c,
                   &i,
                   n)
        return i
    }
}
