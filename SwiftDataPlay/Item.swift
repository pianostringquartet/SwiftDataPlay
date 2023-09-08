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
}

extension MLModel: PersistentModel {
    public var persistentBackingData: BackingData<MLModel> {
        get {
            <#code#>
        }
        set(newValue) {
            <#code#>
        }
    }
    
    public static var schemaMetadata: [Schema.PropertyMetadata] {
        <#code#>
    }
    
    
}

@Model
final class Item {
    var timestamp: Date = Date.now

//    var child: ItemChild? // must be optional b/c cloud-kit
//    var child: ItemChild
    
    // Does not need to be optional, since not a model
//    @Attribute(.transformable(by: ))
    var mood: Mood = Mood.joy(77)
//    var mood: Mood = Mood.complex(<#T##matrix_float4x4#>)
    
    // optional
    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Attribute(.externalStorage)
    var video: Data?
    
    @Attribute(.externalStorage)
//    var mlModel: Data?
//    var mlModel: YOLOv3Tiny?
    var mlModel: MLModel?
        
    init(timestamp: Date,
         child: ItemChild) {
        self.timestamp = timestamp
//        self.mood = .joy(55)
        self.mood = .fear("snakes")
        
        self.image = loadImage()
        self.video = loadVideo()
//        self.mlModel = loadModel()
        self.mlModel = loadModel()
    }
}


func loadImage() -> Data? {
    if let fileURL = Bundle.main.url(
//            forResource: "rodgers",
//            withExtension: "mp4") {
        forResource: "greco2", withExtension: "jpg") {
        if let fileContents = try? Data(contentsOf: fileURL) {
//                self.video = fileContents
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

func loadModel() -> MLModel? {
    
    print("Bundle.main.infoDictionary: \(Bundle.main.infoDictionary)")
    
    if let fileURL = Bundle.main.url(
        forResource: "yolo", withExtension: "mlmodel") {
        
        print("loadModel: fileURL: \(fileURL)")
        
        if let fileContents = try? Data(contentsOf: fileURL) {
            print("loadModel: successfully retrieve data from file!")
            // return fileContents
        } else {
            print("loadModel: could not retrieve data from file...")
        }
        
        if let model = try? MLModel(contentsOf: fileURL) {
            print("loadModel: successfully retrieved MLModel from file!")
            return model
        } else {
            print("loadModel: could not retrieve MLModel from file...")
        }
        
    } else {
        print("loadModel: could not retrieve file...")
    }
    
    return nil
}

//func loadModel() -> Data? {
//    
//    print("Bundle.main.infoDictionary: \(Bundle.main.infoDictionary)")
//    
//    if let fileURL = Bundle.main.url(
//        forResource: "yolo", withExtension: "mlmodelc") {
//
//        if let fileContents = try? Data(contentsOf: fileURL) {
//            print("loadModel: successfully retrieve data from file!")
//            return fileContents
//        } else {
//            print("loadModel: could not retrieve data from file...")
//        }
//    } else {
//        print("loadModel: could not retrieve file...")
//    }
//    
//    return nil
//}


let log = print

// @Model
final class ItemChild {
    var age: Int = 99 // For cloud kit, every property needs a default value
    
    init(age: Int) {
        self.age = age
    }
}
