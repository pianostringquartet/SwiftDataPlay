//
//  PortValueHelpers.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/26/23.
//

import Foundation


protocol PortValueEnum: Equatable, CaseIterable {
    static var portValueTypeGetter: PortValueTypeGetter<Self> { get }
}

typealias PortValueTypeGetter<T> = (T) -> PortValue

enum Plane: String, CaseIterable, Equatable, Codable  {
    case any, horizontal, vertical
}

enum NetworkRequestType: String, CaseIterable, Equatable, Codable, PortValueEnum {
    case get, post // put

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.networkRequestType
    }
}

enum LayerDimension: Equatable, Codable, Hashable {
    case number(CGFloat),
         // visual media layer: resource's inherent dimnensions
         // non-media layer: 100% of parent's dimension
         auto,
         // parentPercent(100), // use 100% of parent dimenion
         // parentPercent(50) // use 50% of parent dimension
         parentPercent(Double)

    init(_ x: CGFloat) {
        self = .number(x)
    }
}

struct LayerSize: Equatable, Codable, Hashable {
    var width: LayerDimension
    var height: LayerDimension
}

typealias StitchPosition = CGSize

struct Point3D: Codable, Equatable, Hashable {
    var x: Double
    var y: Double
    var z: Double

    static let zero = Point3D(x: 0, y: 0, z: 0)
    static let nonZero = Point3D(x: 1, y: 1, z: 1)

    static let multiplicationIdentity = Self.nonZero
    static let additionIdentity = Self.zero
    static let empty = Self.zero
}

struct Point4D: Codable, Equatable, Hashable {
    var x: Double
    var y: Double
    var z: Double
    var w: Double

    static let zero = Point4D(x: 0, y: 0, z: 0, w: 0)
    static let nonZero = Point4D(x: 1, y: 1, z: 1, w: 1)

    static let multiplicationIdentity = Self.nonZero
    static let additionIdentity = Self.zero
    static let empty = Self.zero
}


struct MediaKey: Equatable, Codable, Hashable {

    let filename: String // eg. `dogs`
    let fileExtension: String // eg `.avi`

    var description: String {
        filename + "." + fileExtension
    }
}

struct MediaObjectId: Equatable, Identifiable, Codable, Hashable {
    // An ID that's associated with the original media
    var globalId: UUID

    // Properties specific to the media's location in the node
    var nodeId: NodeId
    var loopIndex: Int

    // Static global ids for default media

    // CoreML Classify
    static let defaultResnetId = UUID()

    // CoreML Detection
    static let defaultYOLOv3TinyId = UUID()

    // 3D Model
    static let toyRobotId = UUID()
    
    var id: String {
        globalId.uuidString + nodeId.description + loopIndex.description
    }
}

enum DataType<Value: Equatable & Codable & Hashable>: Equatable, Codable, Hashable {
    case source(Value)
    case computed
}

struct AsyncMediaValue: Equatable, Codable, Identifiable, Hashable {
    var id: MediaObjectId
    var dataType: DataType<MediaKey>
}


// import SwiftyJSON ?

//struct StitchJSON: Equatable, Codable, Hashable {
//    static func == (lhs: StitchJSON, rhs: StitchJSON) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    var id: UUID
//
//    var value: JSON {
//        didSet {
//            self.id = .init()
//        }
//    }
//
//    // When displaying the JSON to the user,
//    // we want to both pretty-print AND remove escaping slashes;
//    // SwiftyJSON's .description normallly only pretty-prints.
//    var display: String {
//        self.value.descriptionWithoutEscapingSlashes
//    }
//
//    init(_ value: JSON) {
//        self.id = .init()
//        self.value = value
//    }
//}

enum Anchoring: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    
    case topLeft, topCenter, topRight,
         centerLeft, center, centerRight,
         bottomLeft, bottomCenter, bottomRight
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.anchoring
    }
}

enum CameraDirection: String, CaseIterable, Equatable, Codable, PortValueEnum {
    case front, back
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.cameraDirection
    }
}

enum ScrollMode: String, Codable, Equatable, CaseIterable, PortValueEnum {
    case free
    case paging
    case disabled

    static let scrollModeDefault = Self.free

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.scrollMode
    }
}

enum LayerTextAlignment: String, Equatable, Codable, CaseIterable, PortValueEnum {
    case left, center, right, justify

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.textAlignment
    }
}

// Vertical alignment options for our Text Layers in preview window
enum LayerTextVerticalAligment: String, Equatable, Codable, CaseIterable, PortValueEnum {
    case top, center, bottom

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.textVerticalAlignment
    }
}

enum VisualMediaFitStyle: String, CaseIterable, Equatable, Codable, PortValueEnum {
    case fit, fill, stretch
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.fitStyle
    }
}

enum ClassicAnimationCurve: String, Codable, Equatable, CaseIterable, PortValueEnum {
    case linear,
         
         // quadratic
         quadraticIn,
         quadraticOut,
         quadraticInOut,
         
         // sine
         sinusoidalIn,
         sinusoidalOut,
         sinusoidalInOut,
         
         // exponent
         exponentialIn,
         exponentialOut,
         exponentialInOut
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.animationCurve
    }
    
}

enum LightType: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    case ambient, omni, directional,
         spot, IES, probe, area
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.lightType
    }
    
}


enum LayerStroke: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    case none, inside, outside

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.layerStroke
    }
}

enum TextTransform: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    case uppercase, lowercase, capitalize

    static let defaultTransform: Self = .uppercase

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.textTransform
    }
}

enum DateAndTimeFormat: String, Equatable, Hashable, CaseIterable, Codable, PortValueEnum {
    //    case twelveHour, twentyFourHour, mediumDate, longDate
    case none, short, medium, long, full
    
    static let defaultFormat = Self.medium
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.dateAndTimeFormat
    }
    
}

enum ScrollJumpStyle: String, Codable, CaseIterable, PortValueEnum {
    case animated
    case instant

    static let scrollJumpStyleDefault = Self.instant

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.scrollJumpStyle
    }
}

enum ScrollDecelerationRate: String, Codable, CaseIterable, PortValueEnum {
    case normal
    case fast

    static let scrollDecelerationRateDefault = Self.normal

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.scrollDecelerationRate
    }
}


enum DelayStyle: String, Codable, Equatable {
    case always = "Always"
    case increasing = "Increasing"
    case decreasing = "Decreasing"
}

extension DelayStyle: PortValueEnum {
    static var portValueTypeGetter: PortValueTypeGetter<DelayStyle> {
        PortValue.delayStyle
    }
}

enum ShapeCoordinates: String, Codable, Equatable, PortValueEnum {
    case relative = "Relative"
    case absolute = "Absolute"

    static var portValueTypeGetter: PortValueTypeGetter<ShapeCoordinates> {
        PortValue.shapeCoordinates
    }
}

enum ShapeCommandType: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    case closePath, lineTo, moveTo, curveTo

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.shapeCommandType
    }

    static let defaultFalseShapeCommandType: Self = .moveTo
}

// Used for VStack vs HStack on layer groups
enum StitchOrientation: String, Equatable, Codable, CaseIterable, PortValueEnum {
    case none, horizontal, vertical

    static let defaultOrientation = Self.none

    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.orientation
    }

}

enum StitchCameraOrientation: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    case portrait = "Portrait",
         portraitUpsideDown = "Portrait Upside-Down",
         landscapeLeft = "Landscape Left",
         landscapeRight = "Landscape Right"
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.cameraOrientation
    }
    
}


enum StitchDeviceOrientation: String, Equatable, Codable, Hashable, CaseIterable, PortValueEnum {
    
    case unknown = "Unknown",
         portrait = "Portrait",
         portraitUpsideDown = "Portrait Upside-Down",
         landscapeLeft = "Landscape Left",
         landscapeRight = "Landscape Right",
         faceUp = "Face Up",
         faceDown = "Face Down"
    
    static var portValueTypeGetter: PortValueTypeGetter<Self> {
        PortValue.deviceOrientation
    }
}


import CoreGraphics

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
