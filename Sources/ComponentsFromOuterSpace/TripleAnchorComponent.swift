//
//  TripleAnchorComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

#if canImport(RealityKit)
import RealityKit

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
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
#endif
