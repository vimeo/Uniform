//
//  Badge.swift
//  Uniform_Example
//
//  Created by King, Gavin on 10/20/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Uniform

struct Badge: Model
{
    let id: String
    let type: String
}

// MARK: Builder

struct BadgeBuilder: Builder
{
    var id: String
    var type: String
    
    init(object: Badge)
    {
        self.id = object.id
        self.type = object.type
    }
    
    func build() -> Badge
    {
        return Badge(id: self.id, type: self.type)
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
        
        if label == "type"
        {
            if let type = value as? String
            {
                self.type = type
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
    }
}

// MARK: Conformance

extension Badge: Equatable
{
    static func ==(lhs: Badge, rhs: Badge) -> Bool
    {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}

extension Badge: ConsistentObject
{
    var properties: [Property]
    {
        return [
            ("id", self.id),
            ("type", self.type)
        ]
    }
    
    func setting(property: Property) -> Badge
    {
        var builder = BadgeBuilder(object: self)
        
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
