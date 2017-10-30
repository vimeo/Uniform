//
//  User.swift
//  Uniform_Example
//
//  Created by King, Gavin on 9/25/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Uniform

struct User: Model
{
    let id: String
    let name: String
    let age: Int
    let badge: Badge
    let camera: Camera
}

// MARK: Builder

struct UserBuilder: Builder
{
    var id: String
    var name: String
    var age: Int
    var badge: Badge
    var camera: Camera
    
    init(object: User)
    {
        self.id = object.id
        self.name = object.name
        self.age = object.age
        self.badge = object.badge
        self.camera = object.camera
    }
    
    func build() -> User
    {
        return User(id: self.id, name: self.name, age: self.age, badge: self.badge, camera: self.camera)
    }
    
    mutating func set(property label: String, with value: Any) throws
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
        
        if label == "name"
        {
            if let name = value as? String
            {
                self.name = name
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
        
        if label == "age"
        {
            if let age = value as? Int
            {
                self.age = age
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
        
        if label == "badge"
        {
            if let badge = value as? Badge
            {
                self.badge = badge
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
        
        if label == "camera"
        {
            if let camera = value as? Camera
            {
                self.camera = camera
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
        
        throw BuilderError.invalidProperty
    }
}

// MARK: Conformance

extension User: Equatable
{
    static func ==(lhs: User, rhs: User) -> Bool
    {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.age == rhs.age && lhs.badge == rhs.badge && lhs.camera == rhs.camera
    }
}

extension User: ConsistentObject
{
    var consistentProperties: [ConsistentProperty]
    {
        return [
            ("badge", self.badge),
            ("camera", self.camera)
        ]
    }
    
    func setting(consistentProperty: ConsistentProperty) -> User
    {
        var builder = UserBuilder(object: self)
        
        do
        {
            try builder.set(property: consistentProperty.label, with: consistentProperty.object)
        }
        catch
        {
            assertionFailure()
        }
        
        return builder.build()
    }
}
