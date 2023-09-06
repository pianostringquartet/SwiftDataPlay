//
//  StitchMatrix_Float4x4.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import Foundation
import simd

// Note: Although simd_float4 is Codable, it breaks SwiftData as of XCode 15 Beta 7.
/// SwiftData-compatible version of simd_float4
struct StitchSimdFloat4: Equatable, Codable {
   let x: Float
   let y: Float
   let z: Float
   let w: Float
   
   static let zero = Self.init(x: 0, y: 0, z: 0, w: 0)
   
   var asSimd_Float4: simd_float4 {
       .init(x: self.x, y: self.y, z: self.z, w: self.w)
   }
}

extension simd_float4 {
   var asStitchSimdFloat4: StitchSimdFloat4 {
       .init(x: self.x, y: self.y, z: self.z, w: self.w)
   }
}

// SwiftData-compatible version of matrix_float4x4
struct StitchMatrixFloat4x4: Equatable, Codable {
   let columns: [StitchSimdFloat4]
   
   var asMatrix_Float4x4: matrix_float4x4 {
       .init(self.columns[0].asSimd_Float4,
             self.columns[1].asSimd_Float4,
             self.columns[2].asSimd_Float4,
             self.columns[3].asSimd_Float4)
   }
}

extension matrix_float4x4 {
   var asStitchMatrixFloat4x4: StitchMatrixFloat4x4 {
       .init(columns: [
           self.columns.0.asStitchSimdFloat4,
           self.columns.1.asStitchSimdFloat4,
           self.columns.2.asStitchSimdFloat4,
           self.columns.3.asStitchSimdFloat4
       ])
   }
}
