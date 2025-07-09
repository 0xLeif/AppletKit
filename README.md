# AppletKit: A Modular Architecture for Swift Applications

**AppletKit is a template repository for building modern, modular, and scalable applications in Swift.**

It provides a flexible architecture where features are encapsulated into independent modules called **"Applets."** These applets can be developed and tested in isolation but can also seamlessly communicate and share state with one another, creating a cohesive user experience.

This project is designed to be **forked**, providing a robust foundation for your next application.

-----

## The AppletKit Architecture

AppletKit introduces a clean, layered architecture that promotes a unidirectional data flow and clear separation of concerns. This design makes your project easier to manage, scale, and maintain.

The core architectural flow is as follows:

> **`AppletKit`** (The Host Application Shell)
> ⇣
> **`Applets`** & **`Applet Interfaces`** (Independent Feature Modules)
> ⇣
> **`AppletNavigation`** (Manages UI Flow & Routing using AppState)
> ⇣
> **`AppletUI`** (Shared UI Foundation - re-exports SwiftUI & AppState)
> ⇣
> **Services & State** (Global state managed by AppState, local state via SwiftUI)

  * **AppletKit**: The top-level host that assembles and displays the various applets. In the example, `AppletKitView` uses a `TabView`, but this is completely replaceable to suit your app's navigation style (e.g., a `NavigationView`, sidebar, etc.).
  * **Applets**: These are self-contained Swift Packages representing a specific feature or screen of your app. Each applet conforms to the `Applet` protocol and defines its own UI and logic.
  * **Applet Interfaces**: To enable communication, an applet can expose a public `Interface` package. This allows other applets to depend on its shared models and state definitions without depending on its implementation details, preventing tight coupling.
  * **AppletNavigation**: A module dedicated to managing navigation state (e.g., the selected tab). The example uses `AppletTab` and registers it with `AppState`. You can adapt this to handle tabs, stacks, or any custom routing logic your application requires.
  * **AppletUI**: This is a core module providing a shared foundation for all applets. It conveniently re-exports common frameworks like `SwiftUI` and `AppState` (via `@_exported import`). Since the `Applet` protocol itself depends on `AppletUI`, any applet implementation will automatically have `SwiftUI` and `AppState` symbols in scope.
  * **Services & State**: Global application state is managed using the `AppState` library. Individual applets and views can also use standard SwiftUI state management tools (`@State`, `@StateObject`, etc.) for their local state.

-----

## How to Use AppletKit

This repository is a **template**. The best way to start is to create your own copy.

**1. Fork this Repository**
Click the "Fork" button at the top of this page to create a copy under your own GitHub account. You can then clone your forked repository to your local machine.

```bash
git clone https://github.com/YOUR_USERNAME/appletkit.git # Replace YOUR_USERNAME
```

**2. Open in Xcode**
Navigate to the cloned directory and open the `Package.swift` file at the root of the project. Xcode will resolve all the local package dependencies automatically.

**3. Run the Example**
Select a simulator or device and run the project. You will see the example application, which demonstrates two applets (`ExampleApplet` and `ExampleAppletInteroperability`) working together in a `TabView` and sharing state.

-----

## Building Your Application

Once you have the project running, you can start removing the example code and building your own app.

### Two Ways to Use Your Applets

AppletKit offers two primary ways to structure your application:

#### 1\. Use the Central `AppletKitView` Navigator

The default setup uses `AppletKitView` to host your applets in a `TabView`. This is ideal for apps where the main navigation is simple and known ahead of time.

To customize this:

  * **Modify `Sources/AppletKit/AppletKit.swift`** to use your preferred navigation container (e.g., `NavigationView`, a custom sidebar).
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
            YourFirstApplet() // Make sure YourFirstApplet conforms to Applet
            Divider()
            YourSecondApplet() // Make sure YourSecondApplet conforms to Applet
        }
    }
}
```

Even when used independently, applets can still communicate and share data through their **Interface packages** and the shared `AppState` mechanism.

### Creating Your First Applet

1.  **Delete the Examples**: Remove the `Applets/ExampleApplet` and `Applets/ExampleAppletInteroperability` directories. Remember to also remove them from the root `Package.swift` dependencies and target dependencies.

2.  **Create a New Swift Package**: In the `Applets/` directory, create a new Swift package for your feature (e.g., `YourNewApplet`).

3.  **Define the Applet**: Create a struct that conforms to the `Applet` protocol from the `Applet` core module.

    ```swift
    // In: Applets/YourNewApplet/Sources/YourNewApplet/YourNewApplet.swift
    import Applet // Provides the Applet protocol (and transitively SwiftUI & AppState via AppletUI)

    public struct YourNewApplet: Applet {
        public let id: String = "com.your-domain.your-new-applet"
        public let title: String = "My New Applet"

        public init() { } // Required by the Applet protocol

        public var body: some View {
            // Your applet's root view goes here
            Text("Hello from My New Applet!")
        }
    }
    ```

4.  **Update Dependencies**: In the root `Package.swift`, add a dependency on your new applet package and include it in the `AppletKit` target's dependencies.

### Inter-Applet Communication with AppState

The power of this architecture lies in shared state management. The included `AppState` library (from [github.com/0xLeif/AppState](https://github.com/0xLeif/AppState)) provides the `@AppState` property wrapper to access data from a global store.

To allow applets to communicate:

1.  **Create an Interface Package (Optional but Recommended)**: For an applet that needs to expose its data or data structures, create a separate library target in its `Package.swift` (e.g., `YourNewAppletInterface`). This is good practice to avoid circular dependencies if other applets only need the data definition, not the full applet implementation.

2.  **Define Shared State**: In the interface package (or directly in your applet's module if not using a separate interface package), define your `Codable` state object.

    ```swift
    // In: Applets/YourNewApplet/Sources/YourNewAppletInterface/YourAppState.swift (if using an interface package)
    // Or: Applets/YourNewApplet/Sources/YourNewApplet/YourAppState.swift
    import Foundation // Or an appropriate module for your state definition

    public struct YourFeatureState: Codable, Equatable, Sendable { // Ensure it's Codable, Equatable, Sendable
        public var someValue: String = "Initial Value"
        public var counter: Int = 0
    }
    ```

3.  **Register the State with `AppState`**: Extend the `Application` object (from `AppState`) to register your state, making it available via a keypath to the `@AppState` property wrapper. This extension can live in various places:
    *   Within your main `AppletKit` module (e.g., in `AppletKit.swift` or a dedicated `AppState+Extensions.swift` file).
    *   Within the applet module that "owns" or primarily manages this state.
    *   For the example `AppletTab` navigation state, this is done in `Core/AppletNavigation/Sources/AppletNavigation/AppletNavigation.swift`.

    ```swift
    // Example: Place this in your main AppletKit module or where appropriate
    import AppState
    import YourNewAppletInterface // Or YourNewApplet if state is defined there

    extension Application {
        // The keypath for AppState will be \.yourFeatureState
        public var yourFeatureState: State<YourFeatureState> {
            state(initial: YourFeatureState()) // Provide an initial value
        }
    }
    ```

4.  **Depend on the Interface (if applicable)**: Other applets that need to access this shared state should add a dependency on your interface package (e.g., `YourNewAppletInterface`) or the applet package if the state is defined there directly.

5.  **Access Shared State using `@AppState`**: In any applet (or other SwiftUI view), use the `@AppState` property wrapper with the keypath you defined.

    ```swift
    // In an applet that needs to access YourFeatureState:
    // Make sure AppState is imported (usually via AppletUI -> Applet)
    // and the module defining YourFeatureState and its registration is imported.

    import Applet // Or just SwiftUI if not an Applet itself
    // import YourNewAppletInterface // If state is in an interface

    struct InteractingAppletView: View {
        // Access the whole state object
        @AppState(\.yourFeatureState) private var featureState

        // Or access a specific property directly
        @AppState(\.yourFeatureState.someValue) private var sharedValue
        @AppState(\.yourFeatureState.counter) private var sharedCounter

        public var body: some View {
            VStack {
                Text("Shared Value: \(sharedValue)") // Reads "Initial Value" initially
                Text("Shared Counter: \(sharedCounter)") // Reads 0 initially

                Button("Update Value") {
                    sharedValue = "Updated from InteractingApplet!"
                    // This change will reflect in any other view observing \.yourFeatureState.someValue
                }
                Button("Increment Counter") {
                    sharedCounter += 1
                    // This also updates the global state
                }
                Button("Reset Feature State") {
                    // You can modify the whole state object too
                    featureState = YourFeatureState(someValue: "Reset", counter: 0)
                }
            }
            .padding()
        }
    }
    ```

This setup ensures that state changes are propagated throughout your application wherever the state is being observed.

-----

## Next Steps

*   Explore the `ExampleApplet` and `ExampleAppletInteroperability` to see these concepts in action (though you'll likely remove them soon).
*   Dive into the `Core` modules (`Applet`, `AppletNavigation`, `AppletUI`) to understand the foundation.
*   Start building your own applets!

Good luck, and feel free to adapt AppletKit to your project's unique needs!
