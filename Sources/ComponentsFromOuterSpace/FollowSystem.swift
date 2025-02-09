//
//  FollowSystem.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/4/25.
//

import Foundation
import RealityKit
import Spatial

class FollowSystem: System {
    let followers = EntityQuery(where: .has(FollowComponent.self))
    required init(scene: Scene) {
        
    }
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: followers, updatingSystemWhen: .rendering) {
            let followComponent = entity.components[FollowComponent.self]!
            if let target = followComponent.target,
               target.isActive {
                let offset = target.position(relativeTo: entity)
                let distance = sqrt(offset.x * offset.x + offset.y * offset.y + offset.z * offset.z)
                if distance > followComponent.maxDistance {
                    let moveBy = distance - followComponent.maxDistance
                    if let pose = Pose3D(entity.transform.matrix) {
                        let newPose = pose.translated(by: Vector3D(moveBy * normalize(offset)))
                        entity.transform = Transform(newPose)
                    }
                } else if distance > followComponent.minDistance {
                    let moveBy: Float
                    if followComponent.maxDistance > followComponent.minDistance {
                        let percentage = context.deltaTime > 0 ? (1.0 / context.deltaTime) : 0.01
                        let newDistance = percentage * Double(followComponent.maxDistance - followComponent.minDistance)
                        moveBy = (distance - max(Float(newDistance), followComponent.minDistance))
                    } else {
                        moveBy = (distance - followComponent.minDistance)
                    }
                    if let pose = Pose3D(entity.transform.matrix) {
                        let newPose = pose.translated(by: Vector3D(moveBy * normalize(offset)))
                        entity.transform = Transform(newPose)
                    }
                }
            }
        }
    }
}
