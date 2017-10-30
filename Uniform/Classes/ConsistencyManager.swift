//
//  ConsistencyManager.swift
//  Uniform
//

public protocol ConsistentEnvironment: class
{
    var objects: [ConsistentObject] { get }

    func update(with object: ConsistentObject)
}

// MARK: Public API

public class ConsistencyManager
{
    public static let shared = ConsistencyManager()
    
    private let environmentManager = EnvironmentManager()

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
    private class EnvironmentManager
    {
        private struct BoxedEnvironment
        {
            weak var boxed: ConsistentEnvironment?
        }
        
        private var boxedEnvironments: [BoxedEnvironment] = []
        
        func add(_ environment: ConsistentEnvironment)
        {
            let boxedEnvironment = BoxedEnvironment(boxed: environment)
            
            self.boxedEnvironments.append(boxedEnvironment)
        }
        
        var environments: [ConsistentEnvironment]
        {
            // Remove any environments that have been deallocated
            
            let environments = self.boxedEnvironments.flatMap({ $0.boxed })
        
            self.boxedEnvironments = environments.map({ BoxedEnvironment(boxed: $0) })
            
            // Return the unboxed environments
            
            return environments
        }
    }
}
