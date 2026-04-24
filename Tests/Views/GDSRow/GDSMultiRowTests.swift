@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSMultiRowTests {
    @Test("initiate single row")
    func singleRow() throws {
        let rowViewModel = [GDSRowViewModel(
            titleConfig: StyledText(text: "Inactive documents"),
            detailConfig: StyledText(text: "20"),
            iconStyle: IconStyle(icon: "chevron.right"),
            type: .regular
        )]
        let viewModel = GDSMultiRowViewModel(rows: rowViewModel)
        let sut = GDSMultiRow(viewModel: viewModel)
        #expect(sut.backgroundColor == .secondarySystemBackground)
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.row)
        let stack = try #require(sut.subviews.first as? UIStackView)
        #expect(stack.subviews.count == 1)
    }
    
    @Test("initiate multiple rows")
    func multiRow() throws {
        let rowViewModels = [
            GDSRowViewModel(
                titleConfig: StyledText(text: "Inactive documents"),
                detailConfig: StyledText(text: "20"),
                iconStyle: IconStyle(icon: "chevron.right"),
                type: .regular
            ),
            GDSRowViewModel(
                titleConfig: StyledText(text: "HM Armed Forces Veteran Card"),
                subtitleConfig: StyledText(text: "Inactive since 30 October 2025"),
                detailConfig: StyledText(text: "14"),
                image: UIImage(named: "exampleImage", in: .module, compatibleWith: nil),
                iconStyle: IconStyle(icon: "arrow.up.right")
            ),
            GDSRowViewModel(
                titleConfig: StyledText(text: "UK driving licence"),
                image: UIImage(named: "vetCard", in: .module, compatibleWith: nil),
                iconStyle: IconStyle(icon: "arrow.up.right")
            )
        ]
            
        let viewModel = GDSMultiRowViewModel(rows: rowViewModels)
        let sut = GDSMultiRow(viewModel: viewModel)
        #expect(sut.backgroundColor == .secondarySystemBackground)
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.row)
        let stack = try #require(sut.subviews.first as? UIStackView)
        #expect(stack.subviews.count == 3)
        
        let inactiveDocRow = try #require(stack.subviews[0] as? GDSRow)
        #expect(inactiveDocRow.subviews.count == 4)
        let divider = try #require(inactiveDocRow.subviews.last as? GDSDividerView)
        #expect(divider.backgroundColor == DesignSystem.Color.Dividers.default)
        #expect(divider.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == (1 / UIScreen.main.scale) && $0.isActive
        }))
        
        let veteranCardRow = try #require(stack.subviews[1] as? GDSRow)
        _ = try #require(veteranCardRow.subviews.last as? GDSDividerView)

        let drivingLicenseRow = try #require(stack.subviews[2] as? GDSRow)
        #expect(drivingLicenseRow.subviews.count == 3)
    }
}
