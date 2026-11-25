@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSButtonLoadingStateTests {

    private func makeButton() -> GDSButton {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "Test"),
            style: .primary,
            buttonAction: .action({})
        )
        return GDSButton(viewModel: viewModel)
    }

    @Test("Setting isLoading true adds the .loading bit to state")
    func loadingAddsStateBit() {
        let sut = makeButton()
        #expect(!sut.state.contains(.loading))

        sut.isLoading = true
        #expect(sut.state.contains(.loading))
    }

    @Test("Loading puts the button into the disabled state")
    func loadingDisables() {
        let sut = makeButton()
        sut.isLoading = true

        #expect(sut.state.contains(.disabled))
        #expect(!sut.isEnabled)
    }

    @Test("Clearing isLoading removes the .loading bit from state")
    func clearingLoadingRemovesStateBit() {
        let sut = makeButton()
        sut.isLoading = true
        #expect(sut.state.contains(.loading))

        sut.isLoading = false
        #expect(!sut.state.contains(.loading))
    }

    @Test("isLoading getter reflects the backing flag")
    func isLoadingGetterReflectsState() {
        let sut = makeButton()
        #expect(!sut.isLoading)

        sut.isLoading = true
        #expect(sut.isLoading)

        sut.isLoading = false
        #expect(!sut.isLoading)
    }

    @Test("Loading shows the activity indicator via configuration")
    func loadingShowsActivityIndicator() {
        let sut = makeButton()
        sut.isLoading = true
        #expect(sut.configuration?.showsActivityIndicator ?? false)

        sut.isLoading = false
        #expect(!(sut.configuration?.showsActivityIndicator ?? true))
    }
}
