@testable import DesignSystem
import Testing
import UIKit

struct TestKeyboardFocusViewModel: GDSScreenViewModel, KeyboardFocus {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    let preferredFocusAccessibilityIdentifier: String?
}

@MainActor
struct GDSScreenFocusTests {
    private static let focusTargetIdentifier = "focus-target-button"
    
    private func buttonViewModel(
        identifier: String? = GDSScreenFocusTests.focusTargetIdentifier
    ) -> GDSButtonViewModel {
        GDSButtonViewModel(
            title: "test button text",
            style: .primary,
            buttonAction: .action({}),
            accessibilityIdentifier: identifier
        )
    }
    
    /// `true` when the screen is directing focus at a specific view rather than
    /// deferring to the system's default focus order.
    private func directsFocus(_ sut: GDSScreen, to target: UIView) -> Bool {
        sut.preferredFocusEnvironments.contains { ($0 as? UIView) === target }
    }
    
    @Test("Focus is directed to the view named by the view model")
    func directsFocusToNamedView() throws {
        let viewModel = TestKeyboardFocusViewModel(
            screenStyle: .top,
            body: [buttonViewModel()],
            movableFooter: [],
            footer: [],
            preferredFocusAccessibilityIdentifier: Self.focusTargetIdentifier
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let focusTarget = try #require(
            sut.view.firstSubview(withAccessibilityIdentifier: Self.focusTargetIdentifier)
        )
        #expect(sut.preferredFocusEnvironments.count == 1)
        #expect(sut.preferredFocusEnvironments.first as? UIView === focusTarget)
    }
    
    @Test("Focus is directed to a view named in the footer")
    func directsFocusToFooterView() throws {
        let viewModel = TestKeyboardFocusViewModel(
            screenStyle: .top,
            body: [],
            movableFooter: [],
            footer: [buttonViewModel()],
            preferredFocusAccessibilityIdentifier: Self.focusTargetIdentifier
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let focusTarget = try #require(
            sut.view.firstSubview(withAccessibilityIdentifier: Self.focusTargetIdentifier)
        )
        #expect(sut.preferredFocusEnvironments.first as? UIView === focusTarget)
    }
    
    @Test("A nil identifier does not direct focus to any view")
    func nilIdentifierDoesNotDirectFocus() throws {
        let viewModel = TestKeyboardFocusViewModel(
            screenStyle: .top,
            body: [buttonViewModel()],
            movableFooter: [],
            footer: [],
            preferredFocusAccessibilityIdentifier: nil
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        // The button is present in the hierarchy, so a nil identifier - not a
        // missing view - is what prevents focus being directed to it.
        let button = try #require(
            sut.view.firstSubview(withAccessibilityIdentifier: Self.focusTargetIdentifier)
        )
        #expect(directsFocus(sut, to: button) == false)
    }
    
    @Test("An identifier not present in the hierarchy does not direct focus to any view")
    func unknownIdentifierDoesNotDirectFocus() throws {
        let viewModel = TestKeyboardFocusViewModel(
            screenStyle: .top,
            body: [buttonViewModel()],
            movableFooter: [],
            footer: [],
            preferredFocusAccessibilityIdentifier: "not-in-the-hierarchy"
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let button = try #require(
            sut.view.firstSubview(withAccessibilityIdentifier: Self.focusTargetIdentifier)
        )
        #expect(directsFocus(sut, to: button) == false)
    }
    
    @Test("A view model that does not conform to KeyboardFocus does not direct focus")
    func nonConformingViewModelDoesNotDirectFocus() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [buttonViewModel()],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let button = try #require(
            sut.view.firstSubview(withAccessibilityIdentifier: Self.focusTargetIdentifier)
        )
        #expect(directsFocus(sut, to: button) == false)
    }
    
    @Test("The lookup helper finds a nested view by accessibility identifier")
    func lookupFindsNestedView() throws {
        let root = UIView()
        let middle = UIView()
        let leaf = UIView()
        leaf.accessibilityIdentifier = "leaf"
        root.addSubview(middle)
        middle.addSubview(leaf)
        
        #expect(root.firstSubview(withAccessibilityIdentifier: "leaf") === leaf)
        #expect(root.firstSubview(withAccessibilityIdentifier: "missing") == nil)
    }
}
