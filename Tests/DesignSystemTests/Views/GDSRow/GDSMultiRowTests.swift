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
    }
}
