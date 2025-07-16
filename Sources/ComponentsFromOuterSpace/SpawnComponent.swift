//
//  SpawnComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/4/25.
//

#if canImport(RealityKit)
import Foundation
import RealityKit
import Spatial

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
public struct SpawnComponent: Component {
    public var minInterval: TimeInterval
    public var maxInterval: TimeInterval
    public var positionExtent: Rect3D
    public var rotationLockedX: Bool
    public var rotationLockedY: Bool
    public var rotationLockedZ: Bool
    public var spawnEntity: () -> Entity?
    
    public init(minInterval: TimeInterval = 1.0, maxInterval: TimeInterval = 2.0, positionExtent: Rect3D, rotationLockedX: Bool = false, rotationLockedY: Bool = false, rotationLockedZ: Bool = false, spawnEntity: @escaping () -> Entity?) {
        self.minInterval = minInterval
        self.maxInterval = maxInterval
        self.positionExtent = positionExtent
        self.rotationLockedX = rotationLockedX
        self.rotationLockedY = rotationLockedY
        self.rotationLockedZ = rotationLockedZ
        self.spawnEntity = spawnEntity
        Task {
            await SpawnSystem.registerSystem()
        }
    }
}
#endif
