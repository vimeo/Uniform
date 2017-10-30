//
//  ConsistentObject.swift
//  Uniform
//

import Foundation

public typealias ConsistentProperty = (label: String, object: ConsistentObject)

public protocol ConsistentObject
{
    var id: String { get }
    
    var consistentProperties: [ConsistentProperty] { get }

    func setting(consistentProperty: ConsistentProperty) -> Self
}

// MARK: Update API

extension Collection where Element: ConsistentObject, Element: Equatable
{
    // MARK: Synchronous

    public func updated(with object: ConsistentObject) -> (objects: [Element], updatedIndexes: [Int])
    {
        var objects: [Element] = []
        
        var updatedIndexes: [Int] = []
        
        for (index, existingObject) in self.enumerated()
        {
            let updatedObject = existingObject.updated(with: object)
            
            // Append the object
            
            objects.append(updatedObject)
            
            // Append the index if the object changed
            
            if updatedObject != existingObject
            {
                updatedIndexes.append(index)
            }
        }
        
        return (objects, updatedIndexes)
    }
    
    // MARK: Asynchronous

    public func updated(with object: ConsistentObject, on queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), completion: @escaping ([Element], [Int]) -> Void)
    {
        queue.async {
            
            let updated = self.updated(with: object)
            
            DispatchQueue.main.async {
                
                completion(updated.objects, updated.updatedIndexes)
            }
        }
    }
}

extension ConsistentObject
{
    // MARK: Synchronous

    public func updated(with object: ConsistentObject) -> Self
    {
        return object.nodes.reduce(self, { $0.inserting($1) })
    }
    
    // MARK: Asynchronous

    public func updated(with object: ConsistentObject, on queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), completion: @escaping (Self) -> Void)
    {
        queue.async {
            
            let updatedObject = self.updated(with: object)
            
            DispatchQueue.main.async {
                
                completion(updatedObject)
            }
        }
    }
}

// MARK: Helpers

extension ConsistentObject
{
    var nodes: [ConsistentObject]
    {
        return [self] + self.consistentProperties.flatMap({ $0.object.nodes })
    }
    
    func inserting(_ object: ConsistentObject) -> Self
    {
        if let object = object as? Self, object.id == self.id
        {
            return object
        }
        else
        {
            return self.consistentProperties.reduce(self, { $0.setting(consistentProperty: ($1.label, $1.object.inserting(object))) })
        }
    }
}
