//
//  Item.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import Foundation
import SwiftData
import SwiftUI
import CoreML
import Vision

struct LayerNodeId: Equatable, Codable, Hashable, Identifiable {
    let id: NodeId

    init(_ id: UUID) {
        self.id = id
    }
}

typealias NodeId = UUID

enum MaybeId: Equatable, Codable {
//    case present(LayerNodeId),
    case present(Int),
         nothing
    
//    var getSome: LayerNodeId? {
//    var getSome: Int? {
    var getSome: Int {
        switch self {
        case .present(let x): return x
//        default: return nil
        default: return 99999
        }
    }
}

enum Mood: Equatable, Codable {
    case love, 
         joy(Int),
         fear(String)
//       ,  complex(matrix_float4x4)
//    , matrix(simd_float4)
    
//    , simpleMatrix(StitchSimdFloat4) // works
    , stitchMatrix(StitchMatrixFloat4x4) // still crashes SwiftData?
    
//    , color(Color)
    , color(RGBA)
//    , layerId(LayerNodeId)
//    , layerId(LayerNodeId?)
    
//    , layerId(MaybeId)
//    
//    , myNumber(Int?)
    
    , maybeValue(MaybeId)
    
//    var getId: LayerNodeId? {
//        switch self {
////        case .layerId(let x): return x
//        case .layerId(let x): return x.getSome
//        default: return nil
//        }
//    }
//    
//    var getNumber: Int? {
//        switch self {
//        case .myNumber(let x): return x
//        default: return nil
//        }
//    }
    
//    var getMaybeId: LayerNodeId? {
//    var getMaybeId: Int? {
    var getMaybeId: Int {
        switch self {
            //        case .layerId(let x): return x
        case .maybeValue(let x): return x.getSome
//        default: return nil
        default: return 55555
        }
    }
    
    var display: String {
        switch self {
        case .maybeValue: return "MaybeValue"
        default: return "other..."
        }
    }
}


class PortValueTransformer: ValueTransformer {
    // return data
      override func transformedValue(_ value: Any?) -> Any? {
          guard let portValue = value as? PortValue else {
              print("PortValueTransformer: transformedValue: no port value")
//              return nil
              return nil
          }
          do {
//              let data = try NSKeyedArchiver.archivedData(
//                withRootObject: portValue,
//                requiringSecureCoding: true)

              let data = try JSONEncoder().encode(portValue)
              return data
          } catch {
              print("PortValueTransformer: transformedValue: failed")
              return nil
          }
      }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
      
      // return UIColor
      override func reverseTransformedValue(_ value: Any?) -> Any? {
          guard let data = value as? Data else {
              print("PortValueTransformer: reverseTransformedValue: no data")
              return nil
          }
          
          do {
              let portValue = try JSONDecoder().decode(PortValue.self, from: data)
              
//              let portValue = try NSKeyedUnarchiver.unarchivedObject(
//                ofClass: PortValue.self,
//                from: data)
              
              return portValue
          } catch {
              print("PortValueTransformer: reverseTransformedValue: failed")
              return nil
          }
      }
}


@Model
final class Item {
    var timestamp: Date = Date.now
    
    @Transient
    var dogName: String = "Rex"
    
    
    //    var child: ItemChild? // must be optional b/c cloud-kit
    //    var child: ItemChild
    
    // Does not need to be optional, since not a model
    //    @Attribute(.transformable(by: ))
    var mood: Mood = Mood.joy(77)
    //    var mood: Mood = Mood.maybeValue(.none)
    //    var mood: Mood = Mood.maybeValue(.nothing)
    
    //    var mood: Mood = Mood.layerId(.init(UUID()))
    //    var mood: Mood = Mood.myNumber(9)
    
//    var values: [PortValue] = [PortValue.number(999)]
    
//    var value: PortValue = PortValue.number(999)
    
    @Attribute(.transformable(by: PortValueTransformer.self))
    var value: PortValue = PortValue.number(999)
    
//    @Attribute(.transformable(by: ))
//    @Attribute(.transformable(by: { x in
//        x
//    }))
    
    
    
//    @Attribute(.transformable) var value: PortValue {
//        get {
//            _$observationRegistrar.access(self, keyPath: \.value)
//            
//            // return Color(hex: self.getValue(for: \.value))
//            return self.getValue(forKey: \.value)
//           }
//
//           set {
//               _$observationRegistrar.withMutation(of: self, keyPath: \.value) {
//                   self.setValue(forKey: \.value, 
//                                 to: newValue)
//               }
//           }
//    }
//    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Attribute(.externalStorage)
    var video: Data?
    
    init(timestamp: Date,
//         _ values: PortValues) {
         _ values: PortValue) {
        self.timestamp = timestamp
        self.dogName = "Old Yeller"
        self.mood = .joy(55)
//        self.mood = .maybeValue(.nothing)
//        self.mood = .maybeValue(.present(66))
//        self.mood = .maybeValue(.nothing)
//        self.mood = .myNumber(23)
//        self.mood = .myNumber(nil)
//        self.mood = .layerId(.none)
        
//        self.values = values
        print("Item init: value: \(values)")
        self.value = values
        
        
        self.image = loadImage()
        print("Item init: self.value: \(self.value)")
    }
}

typealias PortValues = [PortValue]

func loadImage() -> Data? {
    if let fileURL = Bundle.main.url(
        forResource: "greco2", withExtension: "jpg") {
        if let fileContents = try? Data(contentsOf: fileURL) {
            print("loadImage: successfully retrieve data from file!")
            return fileContents
        } else {
            print("loadImage: could not retrieve data from file...")
        }
    } else {
        print("loadImage: could not retrieve file...")
    }
    
    return nil
}

func loadVideo() -> Data? {
    if let fileURL = Bundle.main.url(
        forResource: "rodgers2", withExtension: "mp4") {
        
        if let fileContents = try? Data(contentsOf: fileURL) {
            print("loadVideo: successfully retrieve data from file!")
            return fileContents
        } else {
            print("loadVideo: could not retrieve data from file...")
        }
    } else {
        print("loadVideo: could not retrieve file...")
    }
    
    return nil
}

let log = print
