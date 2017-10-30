//
//  Camera.swift
//  Uniform_Example
//
//  Created by King, Gavin on 10/20/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Uniform

struct Camera: Model
{
    let id: String
    let name: String
}

// MARK: Builder

struct CameraBuilder: Builder
{
    var id: String
    var name: String
    
    init(object: Camera)
    {
        self.id = object.id
        self.name = object.name
    }
    
    func build() -> Camera
    {
        return Camera(id: self.id, name: self.name)
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
    }
}

// MARK: Conformance

extension Camera: Equatable
{
    static func ==(lhs: Camera, rhs: Camera) -> Bool
    {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension Camera: ConsistentObject
{
    var consistentProperties: [ConsistentProperty]
    {
        return []
    }
    
    func setting(consistentProperty: ConsistentProperty) -> Camera
    {
        var builder = CameraBuilder(object: self)
        
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
