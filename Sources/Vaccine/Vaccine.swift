/// Simple dependency injection library using Swift property wrappers.
///
/// Tired of creating a lot of property on initializers of your classes so it's easier to test them?
/// With **Vaccine** is possible to define properties in your classes using @propertyWrappers in a very simple way!
public enum Vaccine {
    private static var components = [String: Component]()
    
    /// Registers a new dependency to be injected using ``Inject`` property wrapper
    ///
    /// You can call the method to associate some `protocol` with any `struct` or `class`
    /// ```swift
    /// Vaccine.setCure(for: SomeServiceProtocol.self, with: SomeService())
    /// ```
    /// If you want to define the dependency as **singleton**, you can pass the argument `isUnique`
    /// ```swift
    /// Vaccine.setCure(for: SomeServiceProtocol.self, isUnique: true, with: SomeService())
    /// ```
    ///
    /// - Parameters:
    ///   - theProtocol: The protocol that the dependency will conform
    ///   - isUnique: Defines if the dependency will be the same instance (singleton) when it's resolved (defaults to `false`)
    ///   - resolver: The object that will be instantiated when necessary
    public static func setCure<T>(for theProtocol: T.Type, isUnique: Bool = false, with resolver: @escaping @autoclosure () -> T) {
        setCure(for: theProtocol, isUnique: isUnique, resolver)
    }
    
    /// Registers a new dependency to be injected using ``Inject`` property wrapper
    ///
    /// You can call the method to associate some `protocol` with any `struct` or `class`
    /// ```swift
    /// Vaccine.setCure(for: SomeServiceProtocol.self) {
    ///     let item = ["Hello", "World"].randomElement() ?? ""
    ///     return SomeService(text: item)
    /// }
    /// ```
    /// If you want to define the dependency as **singleton**, you can pass the argument `isUnique`
    /// ```swift
    /// Vaccine.setCure(for: SomeServiceProtocol.self, isUnique: true) {
    ///     let item = ["Hello", "World"].randomElement() ?? ""
    ///     return SomeService(text: item)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - theProtocol: The protocol that the dependency will conform
    ///   - isUnique: Defines if the dependency will be the same instance (singleton) when it's resolved (defaults to `false`)
    ///   - resolver: The object that will be instantiated when necessary
    public static func setCure<T>(for theProtocol: T.Type, isUnique: Bool = false, _ resolver: @escaping () -> T) {
        let id = String(describing: theProtocol)
        components.removeValue(forKey: id)
        components[id] = isUnique ? .singleton(resolver()) : .default(resolver)
    }
    
    /// Resolves the instance injected and implemented by the `protocol`, keep in mind that the
    /// application will crash in case this method is used without any register of the dependency
    /// it's recomended to register all the necessary dependencies at the starting point of your
    /// application.
    /// - Parameter theProtocol: The protocol that the dependency is conformed
    /// - Returns: Returns a new instance or an existing one (if `isSingleton` was set to `true`) of the object that conforms to the `protocol`
    public static func getCure<T>(for theProtocol: T.Type) -> T {
        let id = String(describing: theProtocol)
        let component = components[id]
        let item: T?
        
        switch component {
        case let .default(resolver):
            item = resolver() as? T
        case let .singleton(resolved):
            item = resolved as? T
        case .none:
            item = nil
        }
        
        guard let resolvedItem = item else {
            fatalError("Your forgot to register \(id)!")
        }
        return resolvedItem
    }
}

/// Injects an instance of the defined `protocol` to a variable
///
/// To resolve dependencies is pretty simple, simply use ``Inject`` property wrapper inside your class
/// ```swift
/// @Inject(SomeServiceProtocol.self) var service
/// ```
///
/// Remember to register a resolution before using this proprety wrapper.
/// Use ``Vaccine/setCure(for:isUnique:_:)`` or ``Vaccine/setCure(for:isUnique:with:)`` to do it.
@propertyWrapper
public struct Inject<T> {
    /// Resolved object for the determined type
    public let wrappedValue: T
    
    /// Pass any type so **Vaccine** can search for your dependency, just remember you need to register it before.
    /// - Parameter value: Protocol type needed to resolve the dependecy
    public init(_ value: T.Type) {
        self.wrappedValue = Vaccine.getCure(for: value)
    }
}

private enum Component {
    case `default`(() -> Any)
    case singleton(Any)
}
