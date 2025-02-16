//
//  Point3D+Midpoint.swift
//  ComponentsFromOuterSpace
//
//  Created by John Haney on 2/16/25.
//

import Spatial

extension Point3D {
    public func midpoint(to other: Point3D) -> Point3D {
        Point3D(
            x: (x + other.x) / 2.0,
            y: (y + other.y) / 2.0,
            z: (z + other.z) / 2.0
        )
    }
}
