//
//  TripleAnchorComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

import RealityKit

public struct TripleAnchorComponent: Component {
    public let topLeft: [String]
    public let topRight: [String]
    public let bottomRight: [String]
    
    public init(topLeftEntityName: String, topRightEntityName: String, bottomRightEntityName: String) {
        self.topLeft = [topLeftEntityName]
        self.topRight = [topRightEntityName]
        self.bottomRight = [bottomRightEntityName]
        Task {
            await TripleAnchorSystem.registerSystem()
        }
    }
}
