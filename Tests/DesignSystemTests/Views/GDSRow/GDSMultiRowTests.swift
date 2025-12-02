@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSMultiRowTests {
    
    @Test("initiate single row")
    func singleRow() throws {
        let rowViewModel = [GDSRowViewModel(
            title: "Inactive documents",
            detail: "20",
            icon: "chevron.right",
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
                title: "Inactive documents",
                detail: "20",
                icon: "chevron.right",
                type: .regular
            ),
            GDSRowViewModel(
                title: "HM Armed Forces Veteran Card",
                subtitle: "Inactive since 30 October 2025",
                detail: "14",
                image: "exampleImage",
                icon: "arrow.up.right"
            ),
            GDSRowViewModel(
                title: "UK driving licence",
                image: "vetCard",
                icon: "arrow.up.right"
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
        #expect(divider.backgroundColor == .separator)
        #expect(divider.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 0.5 && $0.isActive
        }))
        
        let veteranCardRow = try #require(stack.subviews[1] as? GDSRow)
        _ = try #require(veteranCardRow.subviews.last as? GDSDividerView)

        let drivingLicenseRow = try #require(stack.subviews[2] as? GDSRow)
        #expect(drivingLicenseRow.subviews.count == 3)
    }
}
