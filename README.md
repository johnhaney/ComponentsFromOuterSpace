# ComponentsFromOuterSpace

Components and Systems for RealityKit's Entity Component System

**DualAnchorComponent / DualAnchorSystem**
* Given two names or two "paths" to Entities, an Entity with a DualAnchorComponent will be positioned, rotated, and scaled in the one direction along the distance between the two entities. The scale factor assumes a starting height(y) for Entity of 1, so size your Entity accordingly.

If you map an ARKit HandSkeleton to entities in your scene, then you can create an entity which stretches between the joints to create a skeleton-style visualization.

Example usage:
```
handSkeletonBone.components.set(DualAnchorComponent(
                                bottomEntityPath: ["leftHand", "littleFingerTip"],
                                topEntityPath: ["leftHand", "littleFingerIntermediateTip"]
))
```
