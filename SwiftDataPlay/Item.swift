//
//  Item.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
