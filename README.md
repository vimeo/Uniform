# Uniform

[![CI Status](http://img.shields.io/travis/ghking/Uniform.svg?style=flat)](https://travis-ci.org/ghking/Uniform)
[![Version](https://img.shields.io/cocoapods/v/Uniform.svg?style=flat)](http://cocoapods.org/pods/Uniform)
[![License](https://img.shields.io/cocoapods/l/Uniform.svg?style=flat)](http://cocoapods.org/pods/Uniform)
[![Platform](https://img.shields.io/cocoapods/p/Uniform.svg?style=flat)](http://cocoapods.org/pods/Uniform)

## Purpose

Uniform is a framework for keeping in-memory objects consistent and up to date.

## Motivation

Object consistency is an important consideration, particularly in regard to user interfaces. Keeping in-memory models up to date ensures a consistent experience for the user as they navigate throughout the app.

Consider the following cases:

- The user follows another user. After navigating back to their own profile, they expect their following count to be incremented by one.

- The user likes a video from the player. If the user then closes the player and returns to the video list from which they opened the player, they expect the video in that list to be liked.

- A user manually refreshes a list of videos, one of which whose title has changed since it was last requested. If that same video exists in a list on another tab, the user would expect that video's title to be updated in that list as well.

Uniform provides a system to enable these experiences by maintaining object state in a safe and simple way.

## Documentation

### Two Parts

Uniform is really the combination of two functions: enabling objects to merge with each other, and keeping track of object owners.

#### Mergeable Objects

Objects that care about consistency need to conform to the `ConsistentObject` protocol. This protocol defines a few requirements used to get and set properties by name. Using this interface, the protocol is extended with merge functions that enable a single object to update with another object, or a collection of objects to update with another object.

There are two ways to update with another object.

Synchronously:

```swift
// For a single object

object = object.updated(with: otherObject)
```
```swift
// For a collection of objects

objects = objects.updated(with: otherObject)
```

Asynchronously:

```swift
// For a single object

object.updated(with: otherObject, in: self) { [weak self] (object) in

    guard let strongSelf = self else
    {
        return
    }

    strongSelf.object = object
}
```
```swift
// For a collection of objects

objects.updated(with: otherObject, in: self) { [weak self] (objects) in

    guard let strongSelf = self else
    {
        return
    }

    strongSelf.objects = objects
}
```

All of these functions will perform a deep merge. This means that the object and any of its nested objects will be merged with the other object and any of its nested objects, guaranteeing perfect state parity.

#### Object Ownership

In order for updates to propagate across the app, a registry of object owners must be maintained. This is handled by the `ConsistencyManager`. This object, most likely used as a singleton, keeps track of anyone who owns `ConsistentObject`s. `ConsistentObject` owners need to conform to `ConsistentEnvironment`. This protocol defines methods to both push and pull objects. The aggregate collection of `ConsistentEnvironment`s owned by the `ConsistencyManager` acts almost like a distributed database that's always up to date. This allows Uniform to use no extra memory.

To register with the `ConsistencyManager`, a `ConsistentEnvironment` must call:

```swift
ConsistencyManager.shared.register(self)
```

ConsistencyManager only holds a weak reference to each `ConsistentEnvironment`, so there is no need to unregister.

### Object Consistency

Object consistency throughout the app is the result of using both of these parts.

#### Push API

When objects are updated, either as the result of a network response or a local update, they need to be pushed to the `ConsistencyManager`.

```swift
// For a single object

ConsistencyManager.shared.pushUpdatedObject(object)
```

```swift
// For a collection of objects

ConsistencyManager.shared.pushUpdatedObjects(objects)
```

This will push each new object to each registered `ConsistentEnvironment` using the functions required by the protocol. The `ConsistentEnvironment`s are then responsible for merging the new object into any of it's owned objects using the `ConsistentObject` merge functions.

Here's an example of a `ConsistentEnvironment`:

```swift
class ProfileViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!

    private var user: User
    {
        didSet
        {
            self.label.text = self.user.name
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        ConsistencyManager.shared.register(self)
    }
}

// MARK: Object Consistency

extension ProfileViewController: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return [self.user]
    }

    func update(with object: ConsistentObject)
    {
        self.user = self.user.updated(with: object)
    }
}
```

Because merging accounts for nested objects, even if the updated object is not of the same type as the existing object, it may still update with parts of the updated object. For example, if the existing object is a video and the updated object is a channel, the video may update it's user property with the channels user property if the user has the same identifier.

#### Pull API

The pull API can be used to retrieve the most up to date version of an object or collection of objects.

```swift
// For a single object

ConsistencyManager.shared.pullUpdatedObject(matching: object)
```

```swift
// For a collection of objects

ConsistencyManager.shared.pullUpdatedObjects(matching: objects)
```

These functions direct the `ConsistencyManager` to search through the objects of each registered `ConsistentEnvironment` to find the first instance of an object matching the given object's identifier.

This can be used for situations in which we might have stale objects, such as when we're requesting objects from a cache and want to make sure they're up to date before returning them to the requester.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Minimum Requirements

- Swift 3.2

## Installation

Uniform is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Uniform'
```

## Author

Gavin King, gavin@vimeo.com

## License

Uniform is available under the MIT license. See the LICENSE file for more info.
