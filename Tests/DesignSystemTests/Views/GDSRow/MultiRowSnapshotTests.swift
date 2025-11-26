@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

@MainActor
struct MultiRowSnapshotTests {
    
    @Test("Single tall row with only title")
    func singleTallRowWithOnlyTitle() throws {
        let rowViewModel = GDSRowViewModel(title: "Test Title Label")
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Multiple rows with various styles")
    func multipleTallRowsWithVariousStyles() throws {
        let rowViewModels = [
            GDSRowViewModel(
                title: "Test Title Label 1",
                detail: "20",
                icon: "chevron.right",
                type: .regular
            ),
            GDSRowViewModel(
                title: "Test Title Label 2",
                subtitle: "Test Subtitle",
                detail: "14",
                image: "exampleImage",
                icon: "arrow.up.right"
            ),
            GDSRowViewModel(
                title: "Test Title Label 3",
                image: "vetCard",
                icon: "arrow.up.right"
            )
        ]
            
        let viewModel = GDSMultiRowViewModel(rows: rowViewModels)
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
}
