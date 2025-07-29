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
}
