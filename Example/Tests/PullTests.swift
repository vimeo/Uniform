//
//  PullTests.swift
//  Uniform_Tests
//
//  Created by King, Gavin on 1/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import Uniform

class PullTests: XCTestCase
{
    func testPullUpdatedObject()
    {
        let staleObject1 = Object1(id: "1", integer: 1)
        
        let object1 = Object1(id: "1", integer: 2)
        let object2 = Object2(id: "1", integer: 2, object1: object1, object1s: [object1])
        let object3 = Object3(id: "1", integer: 2, object1: object1, object1s: [object1], object2: object2, object2s: [object2])
        let object3s = [object3]
        
        let environment1 = ObjectEnvironment(thing: object1)
        let environment2 = ArrayEnvironment(things: object3s)

        let consistencyManager = ConsistencyManager()
        
        consistencyManager.register(environment1)
        consistencyManager.register(environment2)
        
        let updatedObject1 = consistencyManager.pullUpdatedObject(for: staleObject1)
        
        XCTAssertEqual(updatedObject1.integer, 2)
    }
    
    func testPullUpdatedObjects()
    {
        let staleObject1 = Object1(id: "1", integer: 1)
        let staleObject1s = [staleObject1]
        
        let object1 = Object1(id: "1", integer: 2)
        let object2 = Object2(id: "1", integer: 2, object1: object1, object1s: [object1])
        let object3 = Object3(id: "1", integer: 2, object1: object1, object1s: [object1], object2: object2, object2s: [object2])
        let object3s = [object3]
        
        let environment1 = ObjectEnvironment(thing: object1)
        let environment2 = ArrayEnvironment(things: object3s)
        
        let consistencyManager = ConsistencyManager()
        
        consistencyManager.register(environment1)
        consistencyManager.register(environment2)
        
        let updatedObject1s = consistencyManager.pullUpdatedObjects(for: staleObject1s)
        
        XCTAssertEqual(updatedObject1s.first?.integer, 2)
    }
}
