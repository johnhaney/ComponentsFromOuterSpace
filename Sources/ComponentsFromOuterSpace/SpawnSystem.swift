//
//  SpawnSystem.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/4/25.
//

import Foundation
import RealityKit
import Spatial

class SpawnSystem: System {
    let spawnpoints = EntityQuery(where: .has(SpawnComponent.self))
    
    required init(scene: Scene) {
    }
    
    func update(context: SceneUpdateContext) {
        let interval = context.deltaTime
        for entity in context.entities(matching: spawnpoints, updatingSystemWhen: .rendering) {
            let spawnComponent = entity.components[SpawnComponent.self]!
            if let timer = entity.components[SpawnTimer.self] {
                if timer.nextSpawn <= interval {
                    self.spawn(at: entity, for: spawnComponent)
                    entity.components.set(self.timer(for: spawnComponent))
                } else {
                    entity.components.set(SpawnTimer(nextSpawn: timer.nextSpawn - interval))
                }
            } else {
                entity.components.set(self.timer(for: spawnComponent))
            }
        }
    }
    
    @MainActor func spawn(at root: Entity, for spawn: SpawnComponent) {
        guard let entity = spawn.spawnEntity() else { return }
        if let pose = Pose3D(entity.transform.matrix) {
            let newPose = pose.rotated(by: Rotation3D(angle: Angle2D.degrees(.random(in: 0..<360)), axis: RotationAxis3D(x: .random(in: -1...1), y: .random(in: -1...1), z: .random(in: -1...1)))).translated(by: Vector3D(x: .random(in: spawn.positionExtent.min.x...spawn.positionExtent.max.x), y: .random(in: spawn.positionExtent.min.y...spawn.positionExtent.max.y), z: .random(in: spawn.positionExtent.min.z...spawn.positionExtent.max.z)))
            entity.transform = Transform(newPose)
        } else {
            let rotation: simd_quatf
            if spawn.rotationLockedX || spawn.rotationLockedY || spawn.rotationLockedZ {
                rotation = simd_quatf(angle: 0, axis: [1,0,0])
            } else {
                rotation = .init(angle: .random(in: -.pi ... .pi), axis: [.random(in: -1...1), .random(in: -1...1), .random(in: -1...1)])
            }
            let translation: SIMD3<Float> = root.transform.translation + [
                Float(.random(in: spawn.positionExtent.min.x...spawn.positionExtent.max.x)),
                Float(.random(in: spawn.positionExtent.min.y...spawn.positionExtent.max.y)),
                Float(.random(in: spawn.positionExtent.min.z...spawn.positionExtent.max.z))
            ]
            entity.transform = Transform(scale: entity.scale, rotation: rotation, translation: translation)
        }
        root.parent?.addChild(entity)
    }
    
    func timer(for spawn: SpawnComponent) -> SpawnTimer {
        SpawnTimer.registerComponent()
        return SpawnTimer(nextSpawn: .random(in: spawn.minInterval...spawn.maxInterval))
    }
    
    struct SpawnTimer: Component {
        var nextSpawn: TimeInterval
    }
}

@available(macOS 15.0, *)
extension Transform {
    init(_ pose: Pose3D) {
        self.init(matrix: simd_float4x4(pose))
    }
}
