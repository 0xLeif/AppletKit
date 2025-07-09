import Applet

/// A simple example applet demonstrating basic functionality and structure.
///
/// This applet serves as a basic template and starting point. Developers can either
/// modify this applet directly or remove it and create their own applets by conforming
/// to the `Applet` protocol.
///
/// To replace this example:
/// 1. Delete the `Applets/ExampleApplet` directory.
/// 2. Remove the dependency on "ExampleApplet" from the main `Package.swift` file.
/// 3. Remove `ExampleApplet()` instantiation from `AppletKitView.swift` (or your custom root view).
public struct ExampleApplet: Applet {
    public let id: String = "example.applet"
    public let title: String = "Example Applet"

    public init() { }

    /// The content view for this applet.
    public var body: some View {
        ExampleAppletRootView()
    }
}
