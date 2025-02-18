//
//  TripleAnchorComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

import RealityKit

public struct TripleAnchorComponent: Component {
    public let topLeft: Entity
    public let topRight: Entity
    public let bottomRight: Entity
    
    public init(topLeftEntity: Entity, topRightEntity: Entity, bottomRightEntity: Entity) {
        self.topLeft = topLeftEntity
        self.topRight = topRightEntity
        self.bottomRight = bottomRightEntity
        Task {
            await TripleAnchorSystem.registerSystem()
        }
    }
}
