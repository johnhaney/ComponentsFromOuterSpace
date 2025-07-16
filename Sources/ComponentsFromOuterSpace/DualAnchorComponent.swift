//
//  DualAnchorComponent.swift
//  SimpleARKitVision
//
//  Created by John Haney on 3/31/24.
//

#if canImport(RealityKit)
import RealityKit

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
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
#endif
