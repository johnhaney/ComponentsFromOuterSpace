//
//  DualAnchorSystem.swift
//  
//
//  Created by John Haney on 4/24/24.
//

import RealityKit
import Spatial

public class DualAnchorSystem: System {
    let query = EntityQuery(where: .has(DualAnchorComponent.self))
    
    required public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: query, updatingSystemWhen: .rendering) {
            guard let component = entity.components[DualAnchorComponent.self]
            else { continue }
            
            let bottom = component.bottomEntity
            let top = component.topEntity
            
            let bottomPosition = Point3D(bottom.position(relativeTo: entity.parent))
            let topPosition = Point3D(top.position(relativeTo: entity.parent))
            
            let applied: DualAnchorAppliedComponent
            if let existingApplied = entity.components[DualAnchorAppliedComponent.self],
               existingApplied.bottomPosition == bottomPosition,
               existingApplied.topPosition == topPosition {
                // already applied and in the same position
                continue
            } else {
                applied = DualAnchorAppliedComponent(bottomPosition: bottomPosition, topPosition: topPosition)
                entity.components.set(applied)
            }
            
            let rotation = Rotation3D(angle: .degrees(90), axis: .x).rotated(by: Rotation3D(position: bottomPosition, target: topPosition))
            
            entity.transform = Transform(matrix: simd_float4x4(AffineTransform3D(scale: Size3D(width: 1, height: length(topPosition.vector - bottomPosition.vector), depth: 1), rotation: rotation, translation: Vector3D((topPosition.vector + bottomPosition.vector)/2))))
        }
    }
}

@available(macOS 15.0, *)
fileprivate struct DualAnchorAppliedComponent: Component {
    let bottomPosition: Point3D
    let topPosition: Point3D
}
