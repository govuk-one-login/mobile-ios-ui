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
    }
}
