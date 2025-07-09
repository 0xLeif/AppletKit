import AppState
import AppletNavigation
import ExampleApplet
import ExampleAppletInteroperability
import SwiftUI

/// The main container view for `AppletKit`.
///
/// In this example implementation, `AppletKitView` uses a `TabView` to host
/// and navigate between `ExampleApplet` and `ExampleAppletInteroperability`.
/// The selection of tabs is managed by `AppletTab` from the `AppletNavigation` module,
/// which is driven by shared application state (`@AppState(\.tab)`).
///
/// ## Customizing or Replacing `AppletKitView`
///
/// This view serves as the primary integration point for applets into the main application UI.
/// Developers forking this repository will likely want to customize or entirely replace
/// this view to suit their application's navigation and layout requirements.
///
/// ### Scenarios for Customization:
///
/// 1.  **Different Navigation**:
///     Instead of a `TabView`, you might use a `NavigationView` with a `List`, a custom sidebar,
///     or programmatic navigation. You would replace the `TabView` structure with your chosen
///     SwiftUI navigation container and instantiate your custom applets within it.
///
/// 2.  **Integrating into an Existing App**:
///     If `AppletKit` is being integrated into a larger, existing application, `AppletKitView`
///     might become a sub-view within that application's hierarchy. Or, you might not use
///     `AppletKitView` at all, instead choosing to instantiate individual applets directly
///     where they are needed in your app's UI. Doing this would result in fractured navigation.
///
/// 3.  **No Applet Chrome**:
///     If your application manages navigation externally and `AppletKit` is only used to
///     display a single applet at a time, `AppletKitView` could be simplified to just
///     display the currently active applet based on some state.
///
/// ### Steps to Customize:
///
/// 1.  **Modify this File**: Change the `body` of `AppletKitView` to implement your desired UI structure.
/// 2.  **Update Navigation State**: If you change the navigation model (e.g., not using `TabView`),
///     you may need to update or replace `Core/AppletNavigation/AppletNavigation.swift` which defines `AppletTab`.
///     Your new view will need to manage its own navigation state.
/// 3.  **Instantiate Your Applets**: Replace `ExampleApplet()` and `ExampleAppletInteroperability()`
///     with instances of your own applets.
///
/// The key is that `AppletKitView` is flexible. Its role is to compose your applets into a cohesive
/// user experience, whatever form that may take.
public struct AppletKitView: View {
    /// The currently selected tab. This state is managed by `AppState` and drives the `TabView`.
    /// If you replace `TabView`, you might replace this with a different state variable
    /// representing your app's current navigation state.
    @AppState(\.tab) private var tab: AppletTab // Specific to the TabView example

    public var body: some View {
        // This TabView is an example. Replace it with your app's desired root navigation.
        TabView(selection: $tab) {
            // Replace ExampleApplet with your own applets.
            ExampleApplet()
                .tabItem {
                    Label("Home (Example)", systemImage: "house")
                }
                .tag(AppletTab.home) // AppletTab.home is part of the example navigation

            // Replace ExampleAppletInteroperability with your own applets.
            ExampleAppletInteroperability()
                .tabItem {
                    Label("Settings (Example)", systemImage: "gear")
                }
                .tag(AppletTab.settings) // AppletTab.settings is part of the example navigation
        }
        // If you don't need a TabView, your body could be as simple as:
        // MyCustomApplet()
        //
        // Or a NavigationView:
        // NavigationView {
        //     List {
        //         NavigationLink("My First Applet", destination: MyFirstApplet())
        //         NavigationLink("My Second Applet", destination: MySecondApplet())
        //     }
        // }
    }
}

#Preview {
    AppletKitView()
}
