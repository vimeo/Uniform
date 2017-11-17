//
//  ConsistencyManager.swift
//  Uniform
//

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
    
    public func update(with object: ConsistentObject)
    {
        self.environmentManager.environments.forEach({ $0.update(with: object) })
    }
    
    // MARK: Pull
    
    public func updatedObject<T: ConsistentObject>(for object: T) -> T?
    {
        return self.environmentManager.environments.flatMap({ $0.objects }).flatMap({ $0.nodes }).flatMap({ $0 as? T }).first(where: { $0.id == object.id })
    }
    
    public func updatedObjects(for objects: [ConsistentObject]) -> (objects: [ConsistentObject], updatedIndexes: [Int])
    {
        var objects = objects
        
        var updatedIndexes: [Int] = []
        
        let nodes = self.environmentManager.environments.flatMap({ $0.objects }).flatMap({ $0.nodes })
        
        for (index, object) in objects.enumerated()
        {
            if let updatedObject = nodes.first(where: { type(of: $0) == type(of: object) && $0.id == object.id })
            {
                objects[index] = updatedObject
                
                updatedIndexes.append(index)
            }
        }
        
        return (objects, updatedIndexes)
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
            
            return self.contexts.flatMap({ $0.environment })
        }
        
        func queue(for environment: ConsistentEnvironment) -> DispatchQueue?
        {
            return self.contexts.first(where: { $0.environment === environment })?.queue
        }
    }
}
