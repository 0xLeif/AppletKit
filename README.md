# AppletKit: A Modular Architecture for Swift Applications

**AppletKit is a template repository for building modern, modular, and scalable applications in Swift.**

It provides a flexible architecture where features are encapsulated into independent modules called **"Applets."** These applets can be developed and tested in isolation but can also seamlessly communicate and share state with one another, creating a cohesive user experience.

This project is designed to be **forked**, providing a robust foundation for your next application.

-----

## The AppletKit Architecture

AppletKit is built on a clean, layered architecture that promotes a clear separation of concerns. This makes your project easier to manage, scale, and maintain. The architecture can be understood in two key ways: the module dependency hierarchy and the data flow.

### Module Dependency Hierarchy

The project is organized into layers, where higher-level modules depend on lower-level ones. This prevents circular dependencies and ensures a clear structure.

  * **`AppletKit`** (The Host Application Shell)
      * Depends on: **`Applets`** (e.g., `ExampleApplet`, `ExampleAppletInteroperability`)
          * Depend on: **`Applet`** & **`AppletUI`** (Core Protocol & Shared UI)
              * Depend on: **`AppletNavigation`** (Manages UI Flow & Routing)
                  * Depends on: **`AppState`** (State Management Library)

### Data Flow

While modules depend on each other in one direction, data flows in a cycle, which keeps the state predictable:

1.  **State**: A central store, managed by the `AppState` library, holds the application's state.
2.  **Views**: Applets and other SwiftUI views read data from `AppState` to render the UI.
3.  **Actions**: User interactions (like tapping a button) modify the properties exposed by `@AppState`.
4.  **Update**: The change is sent back to the central `AppState` store, which updates its value and automatically notifies all subscribed views to re-render with the new information.

This approach decouples the state from the UI, allowing multiple independent applets to react to and modify the same shared data source without needing to know about each other.

-----

## How to Use AppletKit

This repository is a **template**. The best way to start is to create your own copy.

**1. Fork this Repository**
Click the "Fork" button to create a copy under your own GitHub account. Then, clone your forked repository to your local machine.

```bash
git clone https://github.com/YOUR_USERNAME/AppletKit.git # Replace YOUR_USERNAME
```

**2. Open in Xcode**
Navigate to the cloned directory and open the `Package.swift` file at the root of the project. Xcode will resolve all the local package dependencies automatically.

**3. Run the Example**
Select a simulator or device and run the project. You will see the example application, which demonstrates two applets working together in a `TabView` and sharing state.

-----

## Building Your Application

Once you have the project running, you can start removing the example code and building your own app.

### Two Ways to Use Your Applets

AppletKit offers two primary ways to structure your application:

#### 1\. Use the Central `AppletKitView` Navigator

The default setup uses `AppletKitView` to host your applets in a `TabView`. This is ideal for apps where the main navigation is simple and known ahead of time. To customize this:

  * Modify `Sources/AppletKit/AppletKit.swift` to use your preferred navigation container (e.g., `NavigationView`).
  * Instantiate your own applets instead of the examples.

#### 2\. Use Applets Independently

Because each applet is a standalone Swift Package, you don't have to use `AppletKitView` at all. You can import your applets directly into any view in your existing application.

```swift
import SwiftUI
import YourFirstApplet // Assuming you created this applet
import YourSecondApplet // And this one

struct MyCustomView: View {
    var body: some View {
        VStack {
            // Instantiate your applets wherever you need them.
            YourFirstApplet()
            Divider()
            YourSecondApplet()
        }
    }
}
```

Even when used independently, applets can still communicate through their **Interface packages** and the shared `AppState` mechanism.

### Creating Your First Applet

1.  **Delete the Examples**: Remove the `Applets/ExampleApplet` and `Applets/ExampleAppletInteroperability` directories and update the root `Package.swift` dependencies.

2.  **Create a New Swift Package**: In the `Applets/` directory, create a new Swift package for your feature.

3.  **Define the Applet**: Create a struct that conforms to the `Applet` protocol.

    ```swift
    // In: Applets/YourNewApplet/Sources/YourNewApplet/YourNewApplet.swift
    import Applet // Provides the Applet protocol

    public struct YourNewApplet: Applet {
        public let id: String = "your.new.applet"
        public let title: String = "My New Applet"

        public init() { } // Required by the Applet protocol

        public var body: some View {
            Text("Hello from My New Applet!")
        }
    }
    ```

### Inter-Applet Communication with AppState

1.  **Create an Interface Package (Recommended)**: In your applet's `Package.swift`, define a separate library target for the interface (e.g., `ExampleAppletInterface`). This avoids circular dependencies.

2.  **Define Shared State**: In the interface package, define your `Codable`, `Equatable`, and `Sendable` state object.

    ```swift
    // In: Applets/YourNewApplet/Sources/YourNewAppletInterface/YourAppState.swift
    import Foundation

    public struct YourFeatureState: Codable, Equatable, Sendable {
        public var someValue: String = "Initial Value"
        public var counter: Int = 0
    }
    ```

3.  **Register the State**: Extend the `Application` object from `AppState` to register your state with an initial value.

    ```swift
    // In: Applets/YourNewApplet/Sources/YourNewAppletInterface/Application+YourAppState.swift
    import AppState
    
    extension Application {
        public var yourFeatureState: State<YourFeatureState> {
            state(initial: YourFeatureState())
        }
    }
    ```

4.  **Access Shared State**: In any SwiftUI view, use the `@AppState` property wrapper with the keypath you defined to read and write to the shared state.

    ```swift
    import AppletUI
    import YourNewAppletInterface

    struct InteractingAppletView: View {
        @AppState(\.yourFeatureState) private var YourFeatureState

        public var body: some View {
            VStack {
                Text("Shared Counter: \(yourFeatureState.counter)")
                Button("Increment") {
                    sharedCounter += 1
                }
            }
        }
    }
    ```
