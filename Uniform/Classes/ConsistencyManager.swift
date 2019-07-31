//
//  ConsistencyManager.swift
//  Uniform
//

import Foundation

public protocol ConsistentEnvironment: AnyObject
{
    var objects: [ConsistentObject] { get }

    func update(with object: ConsistentObject)
}

public class ConsistencyManager
{
    private let environmentManager = EnvironmentManager()
}

// MARK: Public API

extension ConsistencyManager
{
    public static let shared = ConsistencyManager()
    
    // MARK: Registration

    public func register(_ environment: ConsistentEnvironment)
    {
        self.environmentManager.add(environment)
    }
    
    // MARK: Push
    
    public func pushUpdatedObject(_ object: ConsistentObject)
    {
        self.environmentManager.environments.forEach({ $0.update(with: object) })
    }
    
    public func pushUpdatedObjects(_ objects: [ConsistentObject])
    {
        objects.forEach({ self.pushUpdatedObject($0) })
    }
    
    // MARK: Pull
    
    public func pullUpdatedObject<T: ConsistentObject>(for object: T) -> T
    {
        let updatedObjects = self.environmentManager.environments.flatMap({ $0.objects })

        return updatedObjects.reduce(object, { $0.updated(with: $1) })
    }
    
    public func pullUpdatedObjects<T: ConsistentObject>(for objects: [T]) -> [T]
    {
        return objects.map({ self.pullUpdatedObject(for: $0) })
    }
}

// MARK: Helpers

extension ConsistencyManager
{
    func queue(for environment: ConsistentEnvironment) -> DispatchQueue?
    {
        return self.environmentManager.queue(for: environment)
    }
}

// MARK: Environment Management

extension ConsistencyManager
{
    private class EnvironmentManager
    {
        private struct Constants
        {
            struct Queue
            {
                static let Name = "com.vimeo.uniform"
            }
        }
        
        private struct EnvironmentContext
        {
            weak var environment: ConsistentEnvironment?
            
            let queue: DispatchQueue
        }
        
        private var contexts: [EnvironmentContext] = []
        
        func add(_ environment: ConsistentEnvironment)
        {
            let queue = DispatchQueue(label: Constants.Queue.Name, qos: .userInitiated)
            
            let context = EnvironmentContext(environment: environment, queue: queue)
            
            self.contexts.append(context)
        }
        
        var environments: [ConsistentEnvironment]
        {
            // Remove any environments that have been deallocated
            
            self.contexts = self.contexts.filter({ $0.environment != nil })
            
            // Return the unboxed environments
            
            return self.contexts.compactMap({ $0.environment })
        }
        
        func queue(for environment: ConsistentEnvironment) -> DispatchQueue?
        {
            return self.contexts.first(where: { $0.environment === environment })?.queue
        }
    }
}
