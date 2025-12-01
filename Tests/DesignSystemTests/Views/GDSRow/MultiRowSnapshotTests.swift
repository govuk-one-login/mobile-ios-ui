@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

@MainActor
struct MultiRowSnapshotTests {
    
    @Test("Tall row with only title")
    func tallRowWithOnlyTitle() throws {
        let rowViewModel = GDSRowViewModel(title: "Test Title Label")
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with image, title, subtitle, detail and icon")
    func tallRowWithAllElements() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            image: "vetCard",
            icon: "chevron.right"
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 700, height: 500)
        )
    }
    
    @Test("Tall row with title, subtitle, detail and icon")
    func tallRowWithoutImage() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            icon: "chevron.right"
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with title, detail and icon")
    func tallRowWithoutImageAndSubtitle() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            detail: "20",
            icon: "chevron.right"
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with title and icon")
    func tallRowWithTitleAndIcon() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            icon: "chevron.right"
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with only title")
    func regularRowWithOnlyTitle() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with image, title, subtitle, detail and icon")
    func regularRowWithAllElements() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            image: "vetCard",
            icon: "chevron.right",
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title, subtitle, detail and icon")
    func regularRowWithoutImage() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            icon: "chevron.right",
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title, detail and icon")
    func regularRowWithoutImageAndSubtitle() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            detail: "20",
            icon: "chevron.right",
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title and icon")
    func regularRowWithTitleAndIcon() throws {
        let rowViewModel = GDSRowViewModel(
            title: "Test Title Label",
            icon: "chevron.right",
            type: .regular
        )
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
        
        view.assertSnapshot(
            in: CGSize(width: 700, height: 700)
        )
    }
}
