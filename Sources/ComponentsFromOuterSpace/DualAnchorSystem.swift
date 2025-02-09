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
            
            guard let bottom = entity.findNearest(path: component.bottomEntityPath),
                  let top = entity.findNearest(path: component.topEntityPath)
            else { continue }
            
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

@available(macOS 15.0, *)
extension Entity {
    func findNearest(named: String) -> Entity? {
        return self.findEntity(named: named) ?? parent?.findNearest(named: named)
    }
    
    func findNearest(path: [String]) -> Entity? {
        findNearest(path: path, canBackup: true)
    }
    
    private func findNearest(path: [String], canBackup: Bool) -> Entity? {
        guard let first = path.first
        else { return nil }
        let children = self.findEntities(named: first)
        if !children.isEmpty {
            var subpath = path
            subpath.removeFirst()
            if subpath.isEmpty {
                return children.first
            } else if let found = children.lazy.compactMap({ $0.findNearest(path: subpath, canBackup: false) }).first {
                return found
            } else if canBackup {
                return parent?.findNearest(path: path, canBackup: false)
            } else {
                return nil
            }
        } else if canBackup {
            return parent?.findNearest(path: path, canBackup: false)
        } else {
            return nil
        }
    }
    
    func findEntities(named: String) -> [Entity] {
        (name == named ? [self] : []) +
        children.flatMap({ ($0.name == named ? [$0] : []) + $0.findEntities(named: named) })
    }
}
