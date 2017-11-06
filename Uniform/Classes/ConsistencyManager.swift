//
//  ConsistencyManager.swift
//  Uniform
//

public protocol ConsistentEnvironment: AnyObject
{
    var objects: [ConsistentObject] { get }

    func update(with object: ConsistentObject)
}

// MARK: Public API

public class ConsistencyManager
{
    public static let shared = ConsistencyManager()
    
    let environmentManager = EnvironmentManager()

    public func register(_ environment: ConsistentEnvironment)
    {
        self.environmentManager.add(environment)
    }
    
    public func object<T: ConsistentObject>(matching object: T) -> T?
    {
        return self.environmentManager.environments.flatMap({ $0.objects }).flatMap({ $0.nodes }).flatMap({ $0 as? T }).first(where: { $0.id == object.id })
    }
    
    public func update(with object: ConsistentObject)
    {
        self.environmentManager.environments.forEach({ $0.update(with: object) })
    }
}

// MARK: Environment Management

extension ConsistencyManager
{
    class EnvironmentManager
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
        
        // MARK: Public API
        
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
