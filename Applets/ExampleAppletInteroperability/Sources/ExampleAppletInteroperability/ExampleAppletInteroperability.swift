import Applet

/// An example applet demonstrating how different applets can interact with shared application state.
///
/// This applet, much like `ExampleApplet`, modifies `ExampleAppletState`. Its primary purpose
/// is to show that changes made by one applet can be observed by another, and that multiple
/// applets can contribute to and read from a common state pool.
///
/// To replace or remove this example:
/// 1. Delete the `Applets/ExampleAppletInteroperability` directory.
/// 2. Remove the dependency on "ExampleAppletInteroperability" from the main `Package.swift` file.
/// 3. Remove `ExampleAppletInteroperability()` instantiation from `AppletKitView.swift` (or your custom root view).
public struct ExampleAppletInteroperability: Applet {
    public let id: String = "example.applet.interoperability"
    public let title: String = "Example Interoperability"

    public init() { }

    /// The content view for this applet.
    public var body: some View {
        ExampleAppletInteroperabilityRootView()
    }
}
