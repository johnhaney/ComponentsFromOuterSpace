//
//  TripleAnchorSystem.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

import RealityKit
import Spatial

public class TripleAnchorSystem: System {
    let query = EntityQuery(where: .has(TripleAnchorComponent.self))
    
    required public init(scene: Scene) {}
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: query, updatingSystemWhen: .rendering) {
            guard let component = entity.components[TripleAnchorComponent.self]
            else { continue }
            
            anchorCorners(entity, component.topLeft, component.topRight, component.bottomRight)
        }
    }
    
    @MainActor
    func anchorCorners(_ entity: Entity, _ topLeftPath: [String], _ topRightPath: [String], _ bottomRightPath: [String]) {
        guard let bottomRight = entity.findNearest(path: bottomRightPath),
              let topRight = entity.findNearest(path: topRightPath),
              let top = entity.findNearest(path: topLeftPath)
        else { return }
        
        let bottomRightPosition = Point3D(bottomRight.position(relativeTo: entity.parent))
        let topRightPosition = Point3D(topRight.position(relativeTo: entity.parent))
        let topLeftPosition = Point3D(top.position(relativeTo: entity.parent))

        let applied: TripleAnchorAppliedComponent
        if let existingApplied = entity.components[TripleAnchorAppliedComponent.self],
           existingApplied.bottomRightPosition == bottomRightPosition,
           existingApplied.topRightPosition == topRightPosition,
           existingApplied.topLeftPosition == topLeftPosition {
            return
        } else {
            applied = TripleAnchorAppliedComponent( bottomRightPosition: nil, topLeftPosition: nil, topRightPosition: topRightPosition)
            entity.components.set(applied)
        }
        
        let center = topLeftPosition.midpoint(to: bottomRightPosition)
        
        let up = topRightPosition - bottomRightPosition
        let right = topRightPosition - topLeftPosition
        let forward = right.cross(up)
        
        let rotation = Rotation3D(forward: forward, up: up)
        
        let pose = Pose3D(position: center, rotation: rotation)
        
        var transform = Transform(pose)
        transform.scale = [Float(right.length), Float(up.length), 1]
        entity.transform = transform
    }
}

@available(macOS 15.0, *)
fileprivate struct TripleAnchorAppliedComponent: Component {
    let bottomRightPosition: Point3D?
    let topLeftPosition: Point3D?
    let topRightPosition: Point3D?
}
