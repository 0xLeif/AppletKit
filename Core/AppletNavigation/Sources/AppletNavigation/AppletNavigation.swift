import AppState
import SwiftUI

// MARK: - Example Navigation State (AppletTab)

/// Represents the different tabs available in the example `AppletKitView`'s `TabView`.
///
/// This enum is used in conjunction with `@AppState(\.tab)` to manage the currently
/// selected tab in the example UI.
///
/// ## Customizing Navigation
///
/// If you replace the `TabView` in `AppletKitView` with a different navigation model
/// (e.g., `NavigationView`, a custom sidebar, programmatic navigation), you will likely
/// need to:
///
/// 1.  **Modify or Replace `AppletTab`**:
///     *   If your navigation still uses distinct "tabs" or sections but with different names
///       or more options, you can modify the cases of this enum.
///     *   If your navigation is fundamentally different (e.g., hierarchical, path-based),
///       you might replace `AppletTab` entirely with a new enum, struct, or other type
///       that better represents your navigation state.
///
/// 2.  **Update `AppState` Extension**:
///     The extension `Application.tab` below registers `AppletTab` with `AppState`.
///     If you change `AppletTab` or replace it, you'll need to update this extension
///     accordingly to reflect your new navigation state type and its initial value.
///
/// 3.  **Update `AppletKitView`**:
///     Ensure `AppletKitView` (or your custom root view) uses your new navigation
///     state type to drive its UI.
///
/// For example, if you switch to a `NavigationView` where you can navigate to various
/// screens, your navigation state might be an optional enum representing the current screen,
/// or a navigation path.
public enum AppletTab: String, Sendable, CaseIterable { // CaseIterable for potential dynamic tab creation
    case home
    case settings
    // Add more cases here if you extend the TabView
    // e.g., case profile, case search
}

extension Application {
    /// Provides access to the current `AppletTab` state within the application.
    ///
    /// This is used by `AppletKitView`'s `TabView` to bind its selection.
    /// The `initial: .home` sets the default tab when the application starts.
    ///
    /// If you customize `AppletTab` (e.g., rename it, change its cases, or use a different
    /// type for navigation state), you must update this computed property:
    /// - Change `State<AppletTab>` to `State<YourNavigationStateType>`.
    /// - Update `initial:` to an appropriate default value for your new navigation state.
    public var tab: State<AppletTab> {
        state(initial: .home) // Sets '.home' as the default selected tab.
    }
}

// MARK: END: Example Navigation State -
