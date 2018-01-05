//
//  ConsistentEnvironments.swift
//  Uniform_Example
//
//  Created by King, Gavin on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Uniform

// MARK: Objects

class ObjectEnvironment<T: ConsistentObject>
{
    var thing: T
    
    init(thing: T)
    {
        self.thing = thing
    }
}

class ArrayEnvironment<T: ConsistentObject>
{
    var things: [T]
    
    init(things: [T])
    {
        self.things = things
    }
}

// MARK: Extensions

extension ObjectEnvironment: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return [self.thing]
    }
    
    func update(with object: ConsistentObject)
    {
        self.thing = self.thing.updated(with: object)
    }
}

extension ArrayEnvironment: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return self.things
    }
    
    func update(with object: ConsistentObject)
    {
        self.things = self.things.updated(with: object)
    }
}
