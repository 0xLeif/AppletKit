import AppletUI
import ExampleAppletInterface

/// The root view for the `ExampleApplet`.
///
/// This view demonstrates a basic UI structure within an applet. It displays a title,
/// a piece of text from a shared application state (`ExampleAppletState`), and a button
/// that updates this shared state.
///
/// This `ExampleAppletRootView` is specific to `ExampleApplet`. When creating your own
/// applets, you will design your own root views with the necessary UI and logic.
struct ExampleAppletRootView: View {
    /// Accesses and allows modification of `ExampleAppletState`.
    /// `ExampleAppletState` itself is defined in the `ExampleAppletInterface` module
    /// (see `Applets/ExampleApplet/Sources/ExampleAppletInterface/ExampleAppletState.swift`).
    /// The `@AppState` property wrapper and the system for registering state (e.g., `Application.exampleAppletState`,
    /// likely found in `Application+ExampleApplet.swift` in the interface module) are provided by `Core/AppState`.
    /// This setup allows different applets to interact with the same data.
    ///
    /// In a real application, you would define your own state objects relevant to your app's features,
    /// typically in their own interface modules, and register them with the `AppState` system.
    @AppState(\.exampleAppletState) private var exampleAppletState: ExampleAppletState

    var body: some View {
        VStack {
            Text("Example Applet!")
                .font(.title)
                .padding()

            Spacer()

            // Displays the `exampleValue` from the shared `exampleAppletState`.
            // This demonstrates how an applet can read from shared state.
            Text(exampleAppletState.exampleValue)
                .font(.title3)
                .padding()

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            // This button demonstrates how an applet can modify shared state.
            // Pressing it updates `exampleAppletState.exampleValue` with the current time.
            Button("Update Shared State (from ExampleApplet)") {
                let formattedTime: String = Date.now.formatted(date: .omitted, time: .standard)
                exampleAppletState.exampleValue = "Updated by ExampleApplet at \(formattedTime)"
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    // It's good practice to provide a preview for your applet's root view
    // to facilitate design and development.
    ExampleAppletRootView()
        // For previewing state-dependent views, you might need to mock or provide
        // initial state if AppState isn't configured globally for previews.
        // .environmentObject(MockAppState()) // Example if AppState was an EnvironmentObject
}
