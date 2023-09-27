//
//  PortValue.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/26/23.
//

import Foundation


//enum PortValue: Equatable, Codable, Hashable {
enum PortValue: Equatable, Codable {
    
    case string(String)
    case bool(Bool)
    case int(Int) // e.g  nodeId or index?
    case number(Double) // e.g. CGFloat, part of CGSize, etc.
    case layerDimension(LayerDimension)
    //    case matrixTransform(StitchMatrix)
    case plane(Plane)
    case networkRequestType(NetworkRequestType)
    //    case color(Color)
    //    case size(LayerSize)
    case position(StitchPosition) // TODO: use `CGPoint` instead of `CGSize`
    case point3D(Point3D)
    case point4D(Point4D)
    case pulse(TimeInterval) // TimeInterval = last time this input/output pulsed
    //    case asyncMedia(AsyncMediaValue?)
    //    case json(StitchJSON)
    case none // how to avoid this?
    case anchoring(Anchoring)
    case cameraDirection(CameraDirection)
    case assignedLayer(LayerNodeId?)
    case scrollMode(ScrollMode)
    case textAlignment(LayerTextAlignment)
    case textVerticalAlignment(LayerTextVerticalAligment)
    case fitStyle(VisualMediaFitStyle)
    case animationCurve(ClassicAnimationCurve)
    case lightType(LightType)
    case layerStroke(LayerStroke)
    case textTransform(TextTransform)
    case dateAndTimeFormat(DateAndTimeFormat)
    //    case shape(CustomShape?)
    case scrollJumpStyle(ScrollJumpStyle)
    case scrollDecelerationRate(ScrollDecelerationRate)
    //    case comparable(PortValueComparable?)
    case delayStyle(DelayStyle)
    case shapeCoordinates(ShapeCoordinates)
    case shapeCommandType(ShapeCommandType) // not exposed to user
    //    case shapeCommand(ShapeCommand)
    case orientation(StitchOrientation)
    case cameraOrientation(StitchCameraOrientation)
    case deviceOrientation(StitchDeviceOrientation)
    //    case vnImageCropOption(VNImageCropAndScaleOption)
    
    // This is the 'raw string' that we display to the user
    var display: String {
        switch self {
        case let .string(x):
            return x
        case let .number(x):
            // MARK: string coercison causes perf loss (GitHub issue #3120)
            //            return x.coerceToUserFriendlyString
            return x.description
        case let .layerDimension(x):
            return x.description
        case let .int(x):
            return x.description
        case let .bool(x):
            return x.description
//        case let .color(x):
//            return x.asHexDisplay
//        case let .size(x):
//            return x.asAlgebraicCGSize.asDictionary.description
        case let .position(x):
            return x.asDictionary.description
        case let .point3D(x):
            return x.asDictionary.description
        case let .point4D(x):
            return x.asDictionary.description
//        case .matrixTransform:
//            return "AR Transform"
        case .plane(let plane):
            return plane.rawValue.description
        case .pulse(let time):
            return time.description
        case .none:
            return "none"
            //        case .asyncMedia(let media):
            //            return (media?.mediaKey?.filename ?? nil) ?? "None"
//        case .json(let x):
//            return x.display
        case .networkRequestType(let x):
            return x.rawValue
        case .anchoring(let x):
            return x.rawValue
        case  .cameraDirection(let x):
            return x.rawValue
        case .assignedLayer(let x):
            return x?.id.description ?? "No Layers"
        case .scrollMode(let x):
            return x.rawValue
        case .textAlignment(let x):
            return x.rawValue
        case .textVerticalAlignment(let x):
            return x.rawValue
        case .fitStyle(let x):
            return x.rawValue
        case .animationCurve(let x):
            return x.rawValue
            //        case .importAction:
            //            return "Import"
        case .lightType(let x):
            return x.rawValue
        case .layerStroke(let x):
            return x.rawValue
        case .textTransform(let x):
            return x.rawValue
        case .dateAndTimeFormat(let x):
            return x.rawValue
//        case .shape:
//            return "Shape"
        case .scrollJumpStyle(let x):
            return x.rawValue
        case .scrollDecelerationRate(let x):
            return x.rawValue
            //        case .comparable(let x):
            //            return x?.display ?? "No Value"
        case .delayStyle(let x):
            return x.rawValue
        case .shapeCoordinates(let x):
            return x.rawValue
        case .orientation(let x):
            return x.rawValue.capitalized
        case .cameraOrientation(let x):
            return x.rawValue
        case .shapeCommandType(let x):
            return x.rawValue
            //        case .shapeCommand(let x):
            //            return x.getShapeCommandType.rawValue
        case .deviceOrientation(let x):
            return x.rawValue
            //        case .vnImageCropOption(let x):
            //            return x.label
            
        }
    }
}

extension CGSize {
    var asDictionary: [String: Double] {
        [
            "x": self.width,
            "y": self.height
        ]
    }
}

extension Point3D {
    var asDictionary: [String: Double] {
        [
            "x": self.x,
            "y": self.y,
            "z": self.z
        ]
    }
}

extension Point4D {
    var asDictionary: [String: Double] {
        [
            "x": self.x,
            "y": self.y,
            "z": self.z,
            "w": self.w
        ]
    }
}

let AUTO_SIZE_STRING = "auto"

extension LayerDimension: CustomStringConvertible {
    // MARK: string coercison causes perf loss (GitHub issue #3120)
    var description: String {
        switch self {
        case .auto:
            return AUTO_SIZE_STRING
        case .parentPercent(let x):
            //            return "\(x.coerceToUserFriendlyString)%"
            return x.description
        case .number(let x):
            //            return x.coerceToUserFriendlyString
            return x.description
        }
    }
}
