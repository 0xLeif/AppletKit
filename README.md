# AppletKit: A Modular Swift App Framework

AppletKit is a Swift-based framework designed to provide a modular architecture for building applications. It allows developers to create independent "applets" that can be easily managed and integrated into a main application shell. This repository serves as a template and a starting point for developers looking to build their own applications using this paradigm.

## Getting Started

This project is structured as a Swift Package. You can open and run it using Xcode.

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    ```
2.  Open `Package.swift` in Xcode.
3.  Select a target (e.g., an iOS simulator or device) and run the project.

This will launch the example application, which includes a `TabView` hosting two sample applets: `ExampleApplet` and `ExampleAppletInteroperability`.

## Project Structure

The project is organized into several key directories:

*   **`Sources/AppletKit`**: Contains the main `AppletKitView.swift`, which is the entry point UI for the framework. This view typically hosts the navigation structure (e.g., a `TabView`) for the different applets.
*   **`Applets/`**: This directory houses individual applets. Each applet is its own Swift Package.
    *   **`ExampleApplet/`**: A sample applet demonstrating basic functionality and UI.
    *   **`ExampleAppletInteroperability/`**: Another sample applet that shows how applets can share and interact with common application state.
*   **`Core/`**: Contains core modules used across the framework and potentially by individual applets.
    *   **`Applet/`**: Defines the `Applet` protocol and related structures that applets conform to.
    *   **`AppletNavigation/`**: Includes navigation-related code, such as the `AppletTab` enum used by the example `AppletKitView` for tab-based navigation.
    *   **`AppletUI/`**: (e.g., `Core/AppletUI`) Contains shared UI components or styling. Notably, this module also re-exports `AppState` and `SwiftUI` (via `@_exported import`), making their symbols available to any file that imports `AppletUI`.
    *   **`AppState/`**: (e.g., `Core/AppState`) Provides the `@AppState` property wrapper and the mechanism for managing shared application state that applets can access and modify. The actual state objects (like `ExampleAppletState`) might be defined in interface packages alongside the applets that use them (e.g., `Applets/ExampleApplet/Sources/ExampleAppletInterface/`).

## Forking and Customizing This Repository

This repository is designed to be forked and adapted for your own application needs. Here’s how you can customize it:

### 1. Replacing Example Applets

The provided `ExampleApplet` and `ExampleAppletInteroperability` are placeholders. To create your own application:

1.  **Remove or Modify Example Applets**:
    *   You can delete the directories `Applets/ExampleApplet` and `Applets/ExampleAppletInteroperability`.
    *   Alternatively, you can modify their content to build your first applet.
2.  **Create Your Own Applets**:
    *   It's recommended to create a new Swift Package for each new applet within the `Applets/` directory.
    *   Each applet should define a struct that conforms to the `Applet` protocol (defined in `Core/Applet`). This typically involves specifying an `id`, `title`, and a `body` (which is a SwiftUI `View`).
    ```swift
    // Example: Applets/YourApplet/Sources/YourApplet/YourApplet.swift
    import Applet
    import SwiftUI

    public struct YourApplet: Applet {
        public let id: String = "your.applet.id"
        public let title: String = "My Custom Applet"

        public init() { }

        public var body: some View {
            YourAppletRootView() // Your applet's main view
        }
    }
    ```
3.  **Update Dependencies**:
    *   In the main `Package.swift` (at the root of the repository), remove the dependencies on the example applets and add dependencies to your new applets.
    ```swift
    // In Package.swift
    dependencies: [
        // .package(path: "Applets/ExampleApplet"), // Remove or comment out
        // .package(path: "Applets/ExampleAppletInteroperability"), // Remove or comment out
        .package(path: "Applets/YourApplet"), // Add your applet
    ],
    targets: [
        .target(
            name: "AppletKit",
            dependencies: [
                // "ExampleApplet", // Remove
                // "ExampleAppletInteroperability", // Remove
                "YourApplet", // Add your applet
            ],
            // ...
        ),
        // ...
    ]
    ```

### 2. Customizing Navigation and `AppletKitView`

The default `AppletKitView.swift` uses a `TabView`. You might want a different navigation structure (e.g., a list, side menu, or no explicit chrome if integrating into a larger app).

1.  **Modify `AppletKitView.swift`**:
    *   Open `Sources/AppletKit/AppletKit.swift`.
    *   Change the `TabView` to your desired navigation structure.
    *   Instantiate your custom applets within this view.
    ```swift
    // Example: Modifying AppletKitView.swift
    import SwiftUI
    import YourApplet // Import your applet

    public struct AppletKitView: View {
        // Manage navigation state as needed
        // @State private var selection: YourNavigationEnum = .initialScreen

        public var body: some View {
            // Replace TabView with your custom navigation
            NavigationView {
                List {
                    NavigationLink("Open My Applet", destination: YourApplet())
                    // Add other navigation links or views
                }
            }
            // Or simply:
            // YourApplet() // If AppletKitView is just a container for one applet
        }
    }
    ```

2.  **Adapt `AppletNavigation`**:
    *   The `Core/AppletNavigation/AppletNavigation.swift` file contains `AppletTab`, which is specific to the example `TabView`.
    *   If you change the navigation, you might need to modify or replace this enum with your own navigation state management.
    *   Ensure your `AppletKitView` and any navigation controls correctly use your new navigation state.

### 3. Integrating into Your Existing Application

If you have an existing application and want to use `AppletKit` to manage parts of it:

1.  **Add `AppletKit` as a Package Dependency**:
    *   In your existing app's Xcode project, add `AppletKit` as a Swift Package dependency, pointing to your forked repository.
2.  **Instantiate `AppletKitView`**:
    *   In your app's UI hierarchy (e.g., within a `ContentView` or another view), instantiate `AppletKitView`.
    ```swift
    // In your app's ContentView.swift
    import SwiftUI
    import AppletKit // Assuming your forked package is named AppletKit

    struct ContentView: View {
        var body: some View {
            // Your existing app UI
            // ...

            // Integrate AppletKitView where appropriate
            AppletKitView()
                .frame(height: 300) // Example: Embed it in a part of your UI
        }
    }
    ```
    *   You might not even use the provided `AppletKitView` directly. Instead, you could instantiate your applets directly within your app's views if `AppletKitView`'s structure doesn't fit. The primary benefit comes from the modular applet design.

### 4. State Management (`@AppState` and State Objects)

The example applets (`ExampleApplet` and `ExampleAppletInteroperability`) use the `@AppState` property wrapper to access shared data. This wrapper is provided by the `AppState` module (located in `Core/AppState`).

The actual shared data structure, `ExampleAppletState`, is defined in the `ExampleAppletInterface` module (`Applets/ExampleApplet/Sources/ExampleAppletInterface/ExampleAppletState.swift`). The registration of this state with the `AppState` system (e.g., `Application.exampleAppletState`) is also typically done within this interface module.

When building your application:

*   **Define Your Own Shared State Objects**: If your applets need to share data, create your own Swift structs or classes to hold this data. It's good practice to define these in separate "Interface" packages (similar to `ExampleAppletInterface`) that can be imported by the applets that need them and by the `AppState` registration point.
*   **Register State with `AppState`**: Use the mechanisms provided by the `Core/AppState` module to register your custom state objects so they can be accessed via `@AppState(\.yourCustomState)`.
*   **Scope State**: Consider which state needs to be truly global versus local to an applet or a group of applets. Not all state needs to be in `AppState`; SwiftUI's other state management tools (`@State`, `@StateObject`, `@EnvironmentObject`, etc.) are still valuable for state that is local to a view or applet.

## Core Concepts

*   **`Applet` Protocol (`Core/Applet`)**: The fundamental protocol your applets must conform to. It defines the basic contract for an applet (ID, title, body view).
*   **Modularity**: Each applet is self-contained, making it easier to develop, test, and maintain features independently.
*   **Customizability**: The framework is a starting point. You are encouraged to change the navigation, UI presentation, and core logic to fit your specific application requirements.

By following these guidelines, you can effectively fork this `AppletKit` repository and transform it into the foundation for your own modular Swift application.
