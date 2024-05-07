import XCTest
@testable import ComponentsFromOuterSpace
import ARKit
import RealityKit

final class ComponentsFromOuterSpaceTests: XCTestCase {
    @MainActor
    func testFindNearest() async throws {
        // Find Nearest is very perisstent and tries everything it can to return a result. If some entity exists in the tree with each name in the path provided, then an Entity will be returned.
        // The API will try to continue finding entities which are children of the previously found entity, but has no problem backing all the way up to the top-most parent of self at any point during the search.
        // So the resulting entity will be as "local" as the path lead it along most recently.
        do {
            let result = Entity().findNearest(path: ["one", "two"])
            XCTAssertNil(result)
        }
        do {
            let entity = Entity()
            entity.name = "one"
            let entity2 = Entity()
            entity2.name = "two"
            entity.addChild(entity2)
            let result = entity.findNearest(path: ["one", "two"])
            XCTAssertEqual(entity2, result)
        }
        do {
            let entity = Entity()
            let entity1 = Entity()
            entity1.name = "one"
            entity.addChild(entity1)
            let entity2 = Entity()
            entity2.name = "two"
            entity.addChild(entity2)
            let result = entity.findNearest(path: ["one", "two"])
            XCTAssertEqual(entity2, result)
        }
        do {
            let entity = Entity()
            let entity2 = Entity()
            entity2.name = "two"
            entity.addChild(entity2)
            let result = entity.findNearest(path: ["one", "two"])
            XCTAssertNil(result)
        }
        do {
            // Searching is not strict about order. if entities are found in any order, they will be returned
            let entity = Entity()
            let entity2 = Entity()
            entity2.name = "two"
            entity.addChild(entity2)
            let entity1 = Entity()
            entity1.name = "one"
            entity2.addChild(entity1)
            let result = entity.findNearest(path: ["one", "two"])
            XCTAssertEqual(entity2, result)
        }
        do {
            let entity = Entity()
            do {
                let entity2 = Entity()
                entity2.name = "two"
                entity.addChild(entity2)
            }
            do {
                let entity2 = Entity()
                entity2.name = "two"
                entity.addChild(entity2)
            }
            do {
                let entity2 = Entity()
                entity2.name = "two"
                entity.addChild(entity2)
            }
            do {
                let entity2 = Entity()
                entity2.name = "two"
                entity.addChild(entity2)
            }
            let entity1 = Entity()
            entity1.name = "one"
            entity.addChild(entity1)
            let entity2 = Entity()
            entity2.name = "two"
            entity1.addChild(entity2)
            let result = entity.findNearest(path: ["one", "two"])
            XCTAssertEqual(entity2, result)
        }
        do {
            let entity = Entity()
            let entity3 = Entity()
            entity3.name = "three"
            do {
                let entity4 = Entity()
                entity4.name = "FOUR"
                entity.addChild(entity4)
                entity4.addChild(entity3)
            }
            let entity1 = Entity()
            entity1.name = "one"
            entity.addChild(entity1)
            let entity2 = Entity()
            entity2.name = "two"
            entity1.addChild(entity2)
            
            // This will find entity1, then go to child entity2, then back up and find entity3
            let result = entity.findNearest(path: ["one", "two", "three"])
            XCTAssertEqual(entity3, result)
        }
    }
}
