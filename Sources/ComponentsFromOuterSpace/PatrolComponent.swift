//
//  PatrolComponent.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 3/22/25.
//

import Foundation
import RealityKit

public struct PatrolComponent: Component {
    public let route: [SIMD3<Float>]
    public let speed: Float // meters per second
    
    public init(route: [SIMD3<Float>], speed: Float) {
        self.route = route
        self.speed = speed
        Task {
            await PatrolSystem.registerSystem()
        }
    }
}

public struct PatrolSystem: System {
    let assigned = EntityQuery(where: .has(PatrolComponent.self))
    
    let patrollers = EntityQuery(where: .has(PatrollingComponent.self))
    
    struct PatrollingComponent: Component {
        let target: Int
    }

    public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: assigned, updatingSystemWhen: .rendering) {
            if !entity.components.has(PatrollingComponent.self) {
                if let assignment = entity.components[PatrolComponent.self],
                   !assignment.route.isEmpty {
                    entity.components.set(PatrollingComponent(target: 0))
                } else {
                    entity.components.remove(PatrolComponent.self)
                }
            }
        }
        
        for entity in context.entities(matching: patrollers, updatingSystemWhen: .rendering) {
            // Update this entity unless the original PatrolComponent is removed
            guard let target = entity.components[PatrollingComponent.self],
                  let patrol = entity.components[PatrolComponent.self] else { continue }
            let goal = patrol.route[target.target]
            let toGoal = goal - entity.position
            let scale = entity.transform.scale
            let rotation = simd_quatf(angle: atan2(toGoal.z, toGoal.x), axis: [0,1,0])
            let translation: SIMD3<Float>
            if length(toGoal) <= Float(context.deltaTime) * patrol.speed {
                translation = goal
                entity.components.set(target.nextTarget(patrol.route.count))
            } else {
                translation = entity.transform.translation + Float(context.deltaTime) * patrol.speed * normalize(toGoal)
            }
            entity.transform = Transform(scale: scale, rotation: rotation, translation: translation)
        }
    }
}

extension PatrolSystem.PatrollingComponent {
    func nextTarget(_ count: Int) -> Self {
        Self(target: (target + 1) % count)
    }
}
