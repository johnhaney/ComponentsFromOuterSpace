//
//  Entity.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

#if canImport(RealityKit)
import RealityKit

@available(iOS 18.0, macOS 15.0, tvOS 26.0, *)
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
#endif
