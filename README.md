# Vaccine

![Version](https://img.shields.io/github/v/release/munirwanis/Vaccine?style=flat)
[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/static/v1?label=Platforms&message=iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20Linux&color=brightgreen&style=flat)
![Build](https://img.shields.io/github/workflow/status/munirwanis/Vaccine/Swift?style=flat)
![License](https://img.shields.io/github/license/munirwanis/Vaccine?style=flat)
[![Tweet](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Fmunirwanis%2FVaccine)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2Fmunirwanis%2FVaccine)

## Simple dependency injection library using Swift property wrappers

Tired of creating a lot of property on initializers of your classes so it's easier to test them? With **Vaccine** is possible to define properties in your classes using `@propertyWrapper`s in a very simple way!

## Installation

### Swift Package Manager

In **Xcode** go to `File->Swift Packages->Add Package Dependency...` and paste the url:

`https://github.com/munirwanis/Vaccine.git`

If you are adding this package as a dependency to another package, paste this on your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/munirwanis/Vaccine.git", .upToNextMajor(from: "1.0.0" )),
]
```

### Manual

Since this project has no dependencies, it's possible to drag the source files to your project.

### Other package managers

If manual or SPM are not a option, pull requests will be very welcome to help support other platforms.

## Compatibility

- [X] **Swift 5.1+**
- [X] **Xcode 11+**

## Usage

### Register dependencies

You can use the starting point of your application to register the dependencies that will be resolved later. Let's say we have a protocol for a service called `SomeServiceProtol`, and I want to resolve it with my class `SomeService`.

```swift
import Foundation
import Vaccine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Registers the dependency for my service
        Vaccine.setCure(for: SomeServiceProtocol.self, with: SomeService())

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
```

You can also set the property `isUnique` to `true` to ensure that the object injected is singleton.

```swift
Vaccine.setCure(for: SomeServiceProtocol.self, isUnique: true, with: SomeService())
```

If your object needs to do some complex things you can also pass the resolver as a closure, like this:

```swift
// Can also use `isUnique` property
Vaccine.setCure(for: SomeServiceProtocol.self) {
    let item = ["Hello", "World"].randomElement() ?? ""
    return SomeService(text: item)
}
```

### Resolve dependencies

To resolve dependencies is pretty simple, simply use `@Inject` property wrapper inside your class:

```swift
class SomeViewModel {
    // Will instantiate or get an already instantiated (if singleton) version of  `SomeService`
    @Inject(SomeServiceProtocol.self) var service
    
    func getText() -> String {
        service.getText()
    }
}
```

### Contributions

Found a bug or have a improvement suggestion? Open a issue or help by submitting a Pull Request! 😊
