//
//  DualAnchorComponent.swift
//  SimpleARKitVision
//
//  Created by John Haney on 3/31/24.
//

import RealityKit

public struct DualAnchorComponent: Component {
    public let bottomEntityPath: [String]
    public let topEntityPath: [String]
    
    public init(bottomEntityPath: [String], topEntityPath: [String]) {
        self.bottomEntityPath = bottomEntityPath
        self.topEntityPath = topEntityPath
    }
    
    public init(bottomEntityName: String, topEntityName: String) {
        self.bottomEntityPath = [bottomEntityName]
        self.topEntityPath = [topEntityName]
    }
}
