@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSButtonTests {
    
    @Test func actionTest() {
        var didCallAction = false
        
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .action(
                { didCallAction = true }
            ),
            haptic: .success
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(didCallAction == false)
        sut.sendActions(for: .touchUpInside)
        #expect(didCallAction)
    }
    
    @Test func asyncActionTest() async throws {
        var didCallAction = false
        
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .asyncAction(
                { didCallAction = true }
            ),
            haptic: .success
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(didCallAction == false)
        sut.sendActions(for: .touchUpInside)
        await sut.asyncTask?.value
        #expect(didCallAction)
    }
    
    @Test func isNotSelectable() {
        let viewModel = GDSButtonViewModel(
            title: "test title",
            style: .primary,
            buttonAction: .action({}),
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isSelected)
        sut.sendActions(for: .touchUpInside)
        #expect(!sut.isSelected)
    }
    
    @Test func isSelectable_title() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(
                normal: "title not selected",
                selected: "title selected"
            ),
            style: .primary,
            buttonAction: .action({}),
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isSelected)
        sut.sendActions(for: .touchUpInside)
        #expect(sut.isSelected)
    }
    
    @Test func isNotSelectableAsync() {
        let viewModel = GDSButtonViewModel(
            title: "test title",
            style: .primary,
            buttonAction: .asyncAction({}),
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isSelected)
        sut.sendActions(for: .touchUpInside)
        #expect(!sut.isSelected)
    }
    
    @Test func isSelectableAsync() async {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(
                normal: "title not selected",
                selected: "title selected"
            ),
            style: .primary,
            buttonAction: .asyncAction({}),
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isSelected)
        sut.sendActions(for: .touchUpInside)
        await sut.asyncTask?.value
        #expect(sut.isSelected)
    }
    
    @Test func isSelectable_icon() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(
                normal: "title not selected",
                selected: "title selected"
            ),
            icon: IconForState(normal: .arrowUpRight, selected: .arrowUpRight),
            style: .primary,
            buttonAction: .action({})
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isSelected)
        sut.sendActions(for: .touchUpInside)
        #expect(sut.isSelected)
    }
    
    @Test func isDisabled() async throws {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(
                normal: "title"
            ),
            icon: IconForState(normal: .arrowUpRight, selected: .arrowUpRight),
            style: .primary,
            buttonAction: .asyncAction(
                {
                    try? await Task.sleep(seconds: 0.3)
                }
            )
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(!sut.isLoading)
        sut.sendActions(for: .touchUpInside)
        try await Task.sleep(seconds: 0.1)
        
        #expect(sut.isLoading)
        #expect(sut.configuration?.showsActivityIndicator ?? false)

        await sut.asyncTask?.value
        #expect(!sut.isLoading)
        #expect(!(sut.configuration?.showsActivityIndicator ?? true))
    }
    
    @Test("Button applies maxContentSizeCategory to button and title label when provided")
    func appliesMaxContentSizeCategory() {
        let viewModel = GDSButtonViewModel(
            title: "test title",
            style: .primary,
            buttonAction: .action({}),
            maxContentSizeCategory: .accessibilityExtraLarge
        )
        
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        #expect(sut.maximumContentSizeCategory == .accessibilityExtraLarge)
        #expect(sut.titleLabel?.maximumContentSizeCategory == .accessibilityExtraLarge)
    }
    
    @Test("Button leaves maximumContentSizeCategory unset when not provided")
    func defaultMaxContentSizeCategory() {
        let viewModel = GDSButtonViewModel(
            title: "test title",
            style: .primary,
            buttonAction: .action({})
        )
        
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        // No maxContentSizeCategory provided, so the updater assigns nil
        // and no cap is applied.
        #expect(sut.maximumContentSizeCategory == nil)
        #expect(sut.titleLabel?.maximumContentSizeCategory == nil)
    }
    
    @Test("Button applies maxContentSizeCategory with the TitleForState initialiser")
    func appliesMaxContentSizeCategoryTitleForState() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .action({}),
            maxContentSizeCategory: .accessibilityLarge
        )
        
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        #expect(sut.maximumContentSizeCategory == .accessibilityLarge)
        #expect(sut.titleLabel?.maximumContentSizeCategory == .accessibilityLarge)
    }
    
    @Test("Button updates maxContentSizeCategory when the handler re-runs for the loading state")
    func maxContentSizeCategoryNotAppliedWhileLoading() async throws {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .asyncAction(
                {
                    try? await Task.sleep(seconds: 0.3)
                }
            ),
            maxContentSizeCategory: .accessibilityExtraLarge
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        sut.sendActions(for: .touchUpInside)
        try await Task.sleep(seconds: 0.1)
        
        #expect(sut.isLoading)
        // While loading the updater takes the loading branch, which does not set
        // maximumContentSizeCategory, so it remains unset.
        sut.configurationUpdateHandler?(sut)
        #expect(sut.maximumContentSizeCategory == nil)
        
        await sut.asyncTask?.value
        // Once loading finishes the updater applies the configured cap.
        sut.configurationUpdateHandler?(sut)
        #expect(sut.maximumContentSizeCategory == .accessibilityExtraLarge)
        #expect(sut.titleLabel?.maximumContentSizeCategory == .accessibilityExtraLarge)
    }
    
}
