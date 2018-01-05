//
//  PushTests.swift
//  Uniform_Tests
//
//  Created by King, Gavin on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import Uniform

class PushTests: XCTestCase
{
    // MARK: Pushing Updated Objects to Existing Objects
    
    func testPushUpdatedObjectToExistingMatchingObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        
        let environment = ObjectEnvironment(thing: existingObject1)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject1)
        
        XCTAssertEqual(environment.thing.integer, 2)
    }
    
    func testPushUpdatedObjectToExistingNestingObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject2 = Object2(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1])
        let existingObject3 = Object3(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1], object2: existingObject2, object2s: [existingObject2])
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        
        let environment = ObjectEnvironment(thing: existingObject3)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject1)
        
        XCTAssertEqual(environment.thing.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.thing.object2?.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object2?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.thing.object2s?.first?.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object2s?.first?.object1s?.first?.integer, 2)
    }
    
    func testPushUpdatedObjectToExistingNestedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)

        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject2 = Object2(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1])
        let updatedObject3 = Object3(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1], object2: updatedObject2, object2s: [updatedObject2])
        
        let environment = ObjectEnvironment(thing: existingObject1)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject3)
        
        XCTAssertEqual(environment.thing.integer, 2)
    }

    // MARK: Pushing Updated Objects to Existing Arrays
    
    func testPushUpdatedObjectToExistingArrayContainingObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject1s = [existingObject1]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        
        let environment = ArrayEnvironment(things: existingObject1s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject1)
        
        XCTAssertEqual(environment.things.first?.integer, 2)
    }
    
    func testPushUpdatedObjectToExistingArrayContainingNestingObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject2 = Object2(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1])
        let existingObject3 = Object3(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1], object2: existingObject2, object2s: [existingObject2])
        let existingObject3s = [existingObject3]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        
        let environment = ArrayEnvironment(things: existingObject3s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject1)
        
        XCTAssertEqual(environment.things.first?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2s?.first?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2s?.first?.object1s?.first?.integer, 2)
    }

    func testPushUpdatedObjectToExistingArrayContainingNestedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject1s = [existingObject1]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject2 = Object2(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1])
        let updatedObject3 = Object3(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1], object2: updatedObject2, object2s: [updatedObject2])
        
        let environment = ArrayEnvironment(things: existingObject1s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObject(updatedObject3)
        
        XCTAssertEqual(environment.things.first?.integer, 2)
    }
    
    // MARK: Pushing Updated Arrays to Existing Objects
    
    func testPushUpdatedArrayToExistingContainedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject1s = [updatedObject1]
        
        let environment = ObjectEnvironment(thing: existingObject1)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject1s)
        
        XCTAssertEqual(environment.thing.integer, 2)
    }
    
    func testPushUpdatedArrayToExistingNestingObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject2 = Object2(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1])
        let existingObject3 = Object3(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1], object2: existingObject2, object2s: [existingObject2])
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject1s = [updatedObject1]
        
        let environment = ObjectEnvironment(thing: existingObject3)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject1s)
        
        XCTAssertEqual(environment.thing.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.thing.object2?.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object2?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.thing.object2s?.first?.object1?.integer, 2)
        XCTAssertEqual(environment.thing.object2s?.first?.object1s?.first?.integer, 2)
    }
    
    func testPushUpdatedArrayToExistingNestedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject2 = Object2(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1])
        let updatedObject3 = Object3(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1], object2: updatedObject2, object2s: [updatedObject2])
        let updatedObject3s = [updatedObject3]
        
        let environment = ObjectEnvironment(thing: existingObject1)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject3s)
        
        XCTAssertEqual(environment.thing.integer, 2)
    }
    
    // MARK: Pushing Updated Arrays to Existing Arrays

    func testPushUpdatedArrayToExistingArrayContainingContainedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject1s = [existingObject1]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject1s = [updatedObject1]
        
        let environment = ArrayEnvironment(things: existingObject1s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject1s)
        
        XCTAssertEqual(environment.things.first?.integer, 2)
    }
    
    func testPushUpdatedArrayToExistingArrayContainingObjectNestingContainedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject2 = Object2(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1])
        let existingObject3 = Object3(id: "1", integer: 1, object1: existingObject1, object1s: [existingObject1], object2: existingObject2, object2s: [existingObject2])
        let existingObject3s = [existingObject3]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject1s = [updatedObject1]
        
        let environment = ArrayEnvironment(things: existingObject3s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject1s)
        
        XCTAssertEqual(environment.things.first?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2?.object1s?.first?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2s?.first?.object1?.integer, 2)
        XCTAssertEqual(environment.things.first?.object2s?.first?.object1s?.first?.integer, 2)
    }
    
    func testPushUpdatedArrayToExistingArrayContainingObjectNestedInContainedObject()
    {
        let existingObject1 = Object1(id: "1", integer: 1)
        let existingObject1s = [existingObject1]
        
        let updatedObject1 = Object1(id: "1", integer: 2)
        let updatedObject2 = Object2(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1])
        let updatedObject3 = Object3(id: "1", integer: 2, object1: updatedObject1, object1s: [updatedObject1], object2: updatedObject2, object2s: [updatedObject2])
        let updatedObject3s = [updatedObject3]
        
        let environment = ArrayEnvironment(things: existingObject1s)
        let consistencyManager = ConsistencyManager()
        consistencyManager.register(environment)
        consistencyManager.pushUpdatedObjects(updatedObject3s)
        
        XCTAssertEqual(environment.things.first?.integer, 2)
    }
}
