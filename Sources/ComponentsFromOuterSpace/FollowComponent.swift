//
//  FollowComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/4/25.
//

#if canImport(RealityKit)
import Foundation
import RealityKit

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
public struct FollowComponent: Component {
    public var target: Entity?
    public var minDistance: Float
    public var maxDistance: Float
    public init(target: Entity? = nil, minDistance: Float = 0, maxDistance: Float = 0) {
        self.target = target
        self.minDistance = minDistance
        self.maxDistance = maxDistance
        Task {
            await FollowSystem.registerSystem()
        }
    }
}
#endif
