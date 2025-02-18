//
//  DualAnchorComponent.swift
//  SimpleARKitVision
//
//  Created by John Haney on 3/31/24.
//

import RealityKit

public struct DualAnchorComponent: Component {
    public let bottomEntity: Entity
    public let topEntity: Entity
    
    public init(bottomEntity: Entity, topEntity: Entity) {
        self.bottomEntity = bottomEntity
        self.topEntity = topEntity
        Task {
            await DualAnchorSystem.registerSystem()
        }
    }
}
