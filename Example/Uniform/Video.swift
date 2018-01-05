//
//  Video.swift
//  Uniform_Example
//
//  Created by King, Gavin on 9/25/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Uniform

struct Video: Model
{
    let id: String
    let title: String
    let user: User
}

// MARK: Builder

struct VideoBuilder: Builder
{
    var id: String
    var title: String
    var user: User
    
    init(object: Video)
    {
        self.id = object.id
        self.title = object.title
        self.user = object.user
    }
    
    func build() -> Video
    {
        return Video(id: self.id, title: self.title, user: self.user)
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
        
        if label == "title"
        {
            if let title = value as? String
            {
                self.title = title
                
                return
            }
            else
            {
                throw BuilderError.invalidType
            }
        }
        
        if label == "user"
        {
            if let user = value as? User
            {
                self.user = user
                
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

extension Video: Equatable
{
    static func ==(lhs: Video, rhs: Video) -> Bool
    {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.user == rhs.user
    }
}

extension Video: ConsistentObject
{
    var properties: [Property]
    {
        return [
            ("id", self.id),
            ("title", self.title),
            ("user", self.user)
        ]
    }
    
    func setting(property: Property) -> Video
    {
        var builder = VideoBuilder(object: self)
        
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
