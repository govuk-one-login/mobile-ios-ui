@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

@MainActor
struct MultiRowSnapshotTests {
    @Test("Tall row with only title")
    func tallRowWithOnlyTitle() throws {
        let rowViewModel = GDSRowViewModel(titleConfig: StyledText(text: "Test Title Label"))
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal)
    }
    
    @Test("Tall row with image, title, subtitle, detail and icon")
    func tallRowWithAllElements() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            subtitleConfig: StyledText(text: "Test Subtitle Label"),
            detailConfig: StyledText(text: "20"),
            image: UIImage(named: "vetCard", in: .module, compatibleWith: nil),
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Tall row with title, subtitle, detail and icon")
    func tallRowWithoutImage() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            subtitleConfig: StyledText(text: "Test Subtitle Label"),
            detailConfig: StyledText(text: "20"),
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Tall row with title, detail and icon")
    func tallRowWithoutImageAndSubtitle() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            detailConfig: StyledText(text: "20"),
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Tall row with title and icon")
    func tallRowWithTitleAndIcon() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Regular row with only title")
    func regularRowWithOnlyTitle() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Regular row with image, title, subtitle, detail and icon")
    func regularRowWithAllElements() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            subtitleConfig: StyledText(text: "Test Subtitle Label"),
            detailConfig: StyledText(text: "20"),
            image: UIImage(named: "vetCard", in: .module, compatibleWith: nil),
            iconConfig: StyledIcon(icon: "chevron.right"),
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Regular row with title, subtitle, detail and icon")
    func regularRowWithoutImage() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            subtitleConfig: StyledText(text: "Test Subtitle Label"),
            detailConfig: StyledText(text: "20"),
            iconConfig: StyledIcon(icon: "chevron.right"),
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Regular row with title, detail and icon")
    func regularRowWithoutImageAndSubtitle() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            detailConfig: StyledText(text: "20"),
            iconConfig: StyledIcon(icon: "chevron.right"),
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Regular row with title and icon")
    func regularRowWithTitleAndIcon() throws {
        let rowViewModel = GDSRowViewModel(
            titleConfig: StyledText(text: "Test Title Label"),
            iconConfig: StyledIcon(icon: "chevron.right"),
            type: .regular
        )
        let viewModel = GDSMultiRowViewModel(rows: [rowViewModel])
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 500),
            bindToEdges: .horizontal
        )
    }
    
    @Test("Multiple rows with various styles")
    func multipleTallRowsWithVariousStyles() throws {
        let rowViewModels = [
            GDSRowViewModel(
                titleConfig: StyledText(text: "Test Title Label 1"),
                detailConfig: StyledText(text: "20"),
                iconConfig: StyledIcon(icon: "chevron.right"),
                type: .regular
            ),
            GDSRowViewModel(
                titleConfig: StyledText(text: "Test Title Label 2"),
                subtitleConfig: StyledText(text: "Test Subtitle Label"),
                detailConfig: StyledText(text: "14"),
                image: UIImage(named: "exampleImage", in: .module, compatibleWith: nil),
                iconConfig: StyledIcon(icon: "arrow.up.right")
            ),
            GDSRowViewModel(
                titleConfig: StyledText(text: "Test Title Label 3"),
                image: UIImage(named: "vetCard", in: .module, compatibleWith: nil),
                iconConfig: StyledIcon(icon: "arrow.up.right")
            )
        ]
        let viewModel = GDSMultiRowViewModel(rows: rowViewModels)
        let view = viewModel.createUIView()
        
        view.assertSnapshot(
            in: CGSize(width: 390, height: 700),
            bindToEdges: .horizontal
        )
    }
}
