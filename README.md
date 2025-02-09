# ComponentsFromOuterSpace

Components and Systems for RealityKit's Entity Component System

Current components:
* SpawnComponent - Create new Entities repeatedly based on the minInterval, maxInterval you select. Give a non-zero positionExtent to vary their starting location, and choose whether their rotation should be locked to the Entity which the component is placed on. Provide a closure to generate the newly spawned Entity, so you can vary this as you like.
* FollowComponent - Follow another Entity with a minDistance / maxDistance to allow for the entity to have some variation. Leave the defaults to place at exact same position. Only applies translation, no rotation.
* DualAnchorComponent - Adjusts the transform of the Entity to make the top and bottom of the Entity fit the two entities you specify. This is particularly interesting when used with anchored entities.

**SpawnComponent**
* Spawn new Entities from a randomized location near the Entity's transform at the time.

* Specify minInterval and maxInterval to randomize the minimum timing between calls to spawnEntity()
* Specify a positionExtent Rect3D to determine the translation variation.
* Specify rotationLockedX to prevent rotation around the x-axis.
* Specify rotationLockedY to prevent rotation around the y-axis.
* Specify rotationLockedZ to prevent rotation around the z-axis.
* Provide spawnEntity closure to return a new Entity on demand.

```
public struct SpawnComponent: Component {
    public var minInterval: TimeInterval
    public var maxInterval: TimeInterval
    public var positionExtent: Rect3D
    public var rotationLockedX: Bool
    public var rotationLockedY: Bool
    public var rotationLockedZ: Bool
    public var spawnEntity: () -> Entity?
}
```

**FollowComponent**
* Given a target Entity, this component will translate (but not rotate) the Entity to match the position of the target.
* minDistance and maxDistance of zero (the defaults) will keep this Entity at the same position as the target Entity
* maxDistance > minDistance exhibits this behavior:
* if the Entity is farther away than maxDistance, it will move to maxDistance away from the target.
* if the Entity is nearer than maxDistance but farther than minDistance, it will move closer at a rate of (maxDistance-minDistance) per second until it reaches minDistance and hold at that distance.
* if the Entity is nearer than minDistance, it will not move.
```
public struct FollowComponent: Component {
    public var target: Entity?
    public var minDistance: Float
    public var maxDistance: Float
}
```

**DualAnchorComponent**
* Given two names or two "paths" to Entities, an Entity with a DualAnchorComponent will be positioned, rotated, and scaled in the one direction along the distance between the two entities. The scale factor assumes a starting height(y) for Entity of 1, so size your Entity accordingly.

If you map an ARKit HandSkeleton to entities in your scene, then you can create an entity which stretches between the joints to create a skeleton-style visualization.

Example usage:
```
handSkeletonBone.components.set(DualAnchorComponent(
                                bottomEntityPath: ["leftHand", "littleFingerTip"],
                                topEntityPath: ["leftHand", "littleFingerIntermediateTip"]
))
```
