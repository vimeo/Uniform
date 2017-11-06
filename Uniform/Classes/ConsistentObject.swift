//
//  ConsistentObject.swift
//  Uniform
//

import Foundation

public typealias Property = (label: String, value: Any)

public protocol ConsistentObject
{
    var id: String { get }
    
    var properties: [Property] { get }

    func setting(property: Property) -> Self
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

    public func updated(with object: ConsistentObject, in environment: ConsistentEnvironment, completion: @escaping ([Element], [Int]) -> Void)
    {
        ConsistencyManager.shared.environmentManager.queue(for: environment)?.async {
            
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

    public func updated(with object: ConsistentObject, in environment: ConsistentEnvironment, completion: @escaping (Self) -> Void)
    {
        ConsistencyManager.shared.environmentManager.queue(for: environment)?.async {

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
        return [self] + self.properties.flatMap({ $0.value as? ConsistentObject }).flatMap({ $0.nodes })
    }
    
    func inserting(_ object: ConsistentObject) -> Self
    {
        if let object = object as? Self, object.id == self.id
        {
            return object
        }
        else
        {
            return self.properties.reduce(self, {
                
                if let existingObject = $1.value as? ConsistentObject
                {
                    let property: Property = ($1.label, existingObject.inserting(object))
                    
                    return $0.setting(property: property)
                }
                
                return $0
            })
        }
    }
}
