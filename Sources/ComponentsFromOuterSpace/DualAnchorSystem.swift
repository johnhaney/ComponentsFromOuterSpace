//
//  DualAnchorSystem.swift
//  
//
//  Created by John Haney on 4/24/24.
//

#if canImport(RealityKit)
import RealityKit
import Spatial

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
public class DualAnchorSystem: System {
    let query = EntityQuery(where: .has(DualAnchorComponent.self))
    
    required public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: query, updatingSystemWhen: .rendering) {
            guard let component = entity.components[DualAnchorComponent.self]
            else { continue }
            
            let bottom = component.bottomEntity
            let top = component.topEntity
            
            let bottomPosition: Point3D
            let topPosition: Point3D
            if let parent = entity.parent {
                bottomPosition = Point3D(bottom.position(relativeTo: parent))
                topPosition = Point3D(top.position(relativeTo: parent))
            } else {
                bottomPosition = Point3D(bottom.position)
                topPosition = Point3D(top.position)
            }
            
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

@available(macOS 15.0, tvOS 26.0, *)
fileprivate struct DualAnchorAppliedComponent: Component {
    let bottomPosition: Point3D
    let topPosition: Point3D
}
#endif
