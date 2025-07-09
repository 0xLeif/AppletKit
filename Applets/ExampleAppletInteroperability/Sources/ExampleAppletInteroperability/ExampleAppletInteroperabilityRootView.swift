import AppletUI
import ExampleAppletInterface

/// The root view for the `ExampleAppletInteroperability`.
///
/// This view is very similar to `ExampleAppletRootView`. It also interacts with
/// the shared `ExampleAppletState` to demonstrate that multiple, independent applets
/// can read from and write to the same piece of application state.
///
/// When forking this repository, you would replace this with the specific UI for
/// your own applet that might need to interoperate with others.
struct ExampleAppletInteroperabilityRootView: View {
    /// Accesses the same shared `ExampleAppletState` as `ExampleApplet`.
    /// This allows `ExampleAppletInteroperability` to see changes made by `ExampleApplet`
    /// and vice-versa.
    @AppState(\.exampleAppletState) private var exampleAppletState: ExampleAppletState

    var body: some View {
        VStack {
            Text("Example Applet Interoperability!")
                .font(.title)
                .padding()

            Spacer()

            // Displays the `exampleValue` from `exampleAppletState`.
            // This value could have been set by this applet or by `ExampleApplet`.
            Text(exampleAppletState.exampleValue)
                .font(.title3)
                .padding()

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            // This button updates the shared state, specifically indicating that
            // the update originated from `ExampleAppletInteroperability`.
            Button("Update Shared State (from Interoperability)") {
                let formattedTime: String = Date.now.formatted(date: .omitted, time: .standard)
                exampleAppletState.exampleValue = "Updated by InteropApplet at \(formattedTime)"
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    ExampleAppletInteroperabilityRootView()
    // As with ExampleAppletRootView, consider mocking state for previews if necessary.
}
