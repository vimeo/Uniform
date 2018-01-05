//
//  ConsistentObjects.swift
//  Uniform_Example
//
//  Created by King, Gavin on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

@testable import Uniform

// MARK: Objects

struct Object1: Model
{
    var id: String
    var integer: Int
}

struct Object2: Model
{
    var id: String
    var integer: Int
    var object1: Object1?
    var object1s: [Object1]?
}

struct Object3: Model
{
    var id: String
    var integer: Int
    var object1: Object1?
    var object1s: [Object1]?
    var object2: Object2?
    var object2s: [Object2]?
}

// MARK: Extensions (Generated)

extension Object1: ConsistentObject
{
    var properties: [Property]
    {
        return [
            (label: "id", value: self.id),
            (label: "integer", value: self.integer)
        ]
    }

    func setting(property: Property) -> Object1
    {
        var builder = Object1Builder(object: self)

        do
        {
            try builder.set(property: property.label, with: property.value)
        }
        catch
        {
            assertionFailure()
        }

        return builder.build()
    }
}

extension Object2: ConsistentObject
{
    var properties: [Property]
    {
        return [
            (label: "id", value: self.id),
            (label: "integer", value: self.integer),
            (label: "object1", value: self.object1),
            (label: "object1s", value: self.object1s)
        ]
    }

    func setting(property: Property) -> Object2
    {
        var builder = Object2Builder(object: self)

        do
        {
            try builder.set(property: property.label, with: property.value)
        }
        catch
        {
            assertionFailure()
        }

        return builder.build()
    }
}

extension Object3: ConsistentObject
{
    var properties: [Property]
    {
        return [
            (label: "id", value: self.id),
            (label: "integer", value: self.integer),
            (label: "object1", value: self.object1),
            (label: "object1s", value: self.object1s),
            (label: "object2", value: self.object2),
            (label: "object2s", value: self.object2s)
        ]
    }

    func setting(property: Property) -> Object3
    {
        var builder = Object3Builder(object: self)

        do
        {
            try builder.set(property: property.label, with: property.value)
        }
        catch
        {
            assertionFailure()
        }

        return builder.build()
    }
}

// MARK: Builders (Generated)

struct Object1Builder: Builder
{
    var id: String
    var integer: Int

    init(object: Object1)
    {
        self.id = object.id
        self.integer = object.integer
    }

    func build() -> Object1
    {
        return Object1(id: self.id, integer: self.integer)
    }

    mutating func set(property label: String, with value: Any?) throws
    {
        if label == "id"
        {
            if let id = value as? String
            {
                self.id = id

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "integer"
        {
            if let integer = value as? Int
            {
                self.integer = integer

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
    }
}

struct Object2Builder: Builder
{
    var id: String
    var integer: Int
    var object1: Object1?
    var object1s: [Object1]?

    init(object: Object2)
    {
        self.id = object.id
        self.integer = object.integer
        self.object1 = object.object1
        self.object1s = object.object1s
    }

    func build() -> Object2
    {
        return Object2(id: self.id, integer: self.integer, object1: self.object1, object1s: self.object1s)
    }

    mutating func set(property label: String, with value: Any?) throws
    {
        if label == "id"
        {
            if let id = value as? String
            {
                self.id = id

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "integer"
        {
            if let integer = value as? Int
            {
                self.integer = integer

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object1"
        {
            if let object1 = value as? Object1?
            {
                self.object1 = object1

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object1s"
        {
            if let object1s = value as? [Object1]?
            {
                self.object1s = object1s

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
    }
}

struct Object3Builder: Builder
{
    var id: String
    var integer: Int
    var object1: Object1?
    var object1s: [Object1]?
    var object2: Object2?
    var object2s: [Object2]?

    init(object: Object3)
    {
        self.id = object.id
        self.integer = object.integer
        self.object1 = object.object1
        self.object1s = object.object1s
        self.object2 = object.object2
        self.object2s = object.object2s
    }

    func build() -> Object3
    {
        return Object3(id: self.id, integer: self.integer, object1: self.object1, object1s: self.object1s, object2: self.object2, object2s: self.object2s)
    }

    mutating func set(property label: String, with value: Any?) throws
    {
        if label == "id"
        {
            if let id = value as? String
            {
                self.id = id

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "integer"
        {
            if let integer = value as? Int
            {
                self.integer = integer

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object1"
        {
            if let object1 = value as? Object1?
            {
                self.object1 = object1

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object1s"
        {
            if let object1s = value as? [Object1]?
            {
                self.object1s = object1s

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object2"
        {
            if let object2 = value as? Object2?
            {
                self.object2 = object2

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }

        if label == "object2s"
        {
            if let object2s = value as? [Object2]?
            {
                self.object2s = object2s

                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
    }
}

