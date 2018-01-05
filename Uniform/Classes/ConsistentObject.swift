//
//  ConsistentObject.swift
//  Uniform
//

import Foundation

public typealias Property = (label: String, value: Any?)

public protocol ConsistentObject
{
    var id: String { get }
    
    var properties: [Property] { get }

    func setting(property: Property) -> Self
}

// MARK: Public API

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
        ConsistencyManager.shared.queue(for: environment)?.async {

            let updatedObject = self.updated(with: object)
            
            DispatchQueue.main.async {
                
                completion(updatedObject)
            }
        }
    }
}

extension Array where Element: ConsistentObject
{
    // MARK: Synchronous
    
    public func updated(with object: ConsistentObject) -> [Element]
    {
        return self.map({ $0.updated(with: object) })
    }
    
    // MARK: Asynchronous
    
    public func updated(with object: ConsistentObject, in environment: ConsistentEnvironment, completion: @escaping ([Element]) -> Void)
    {
        ConsistencyManager.shared.queue(for: environment)?.async {
            
            let updatedObjects = self.updated(with: object)
            
            DispatchQueue.main.async {
                
                completion(updatedObjects)
            }
        }
    }
}

// MARK: Private Helpers

extension ConsistentObject
{
    private var nodes: [ConsistentObject]
    {
        return self.properties.reduce(into: [self], {
            
            // Handle consistent object properties
            
            if let object = $1.value as? ConsistentObject
            {
                $0 = $0 + object.nodes
            }
                
            // Handle consistent object array properties
                
            else if let objects = $1.value as? [ConsistentObject]
            {
                $0 = $0 + objects.flatMap({ $0.nodes })
            }
        })
    }
    
    private func inserting(_ object: ConsistentObject) -> Self
    {
        if let object = object as? Self, object.id == self.id
        {
            return object
        }
        else
        {
            return self.properties.reduce(self, {
                
                var updatedValue = $1.value
                
                // Handle consistent object properties
                
                if let existingValue = $1.value as? ConsistentObject
                {
                    updatedValue = existingValue.inserting(object)
                }
                
                // Handle consistent object array properties
                
                else if let existingValue = $1.value as? [ConsistentObject]
                {
                    updatedValue = existingValue.map({ $0.inserting(object) })
                }
                
                // Set the updated property
                
                let property: Property = ($1.label, updatedValue)
                
                return $0.setting(property: property)
            })
        }
    }
}
