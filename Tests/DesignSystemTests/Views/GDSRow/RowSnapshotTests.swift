@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

@MainActor
struct RowSnapshotTests {
    
    @Test("Tall row with only title")
    func tallRowWithOnlyTitle() throws {
        let viewModel = GDSRowViewModel(title: "Test Title Label")
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with image, title, subtitle, detail and icon")
    func tallRowWithAllElements() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            image: "vetCard",
            icon: "chevron.right"
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with title, subtitle, detail and icon")
    func tallRowWithoutImage() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            icon: "chevron.right"
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with title, detail and icon")
    func tallRowWithoutImageAndSubtitle() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            detail: "20",
            icon: "chevron.right"
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Tall row with title and icon")
    func tallRowWithTitleAndIcon() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            icon: "chevron.right"
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with only title")
    func regularRowWithOnlyTitle() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            type: .regular
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with image, title, subtitle, detail and icon")
    func regularRowWithAllElements() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            image: "vetCard",
            icon: "chevron.right",
            type: .regular
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title, subtitle, detail and icon")
    func regularRowWithoutImage() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            subtitle: "Test Subtitle Label",
            detail: "20",
            icon: "chevron.right",
            type: .regular
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title, detail and icon")
    func regularRowWithoutImageAndSubtitle() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            detail: "20",
            icon: "chevron.right",
            type: .regular
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
    
    @Test("Regular row with title and icon")
    func regularRowWithTitleAndIcon() throws {
        let viewModel = GDSRowViewModel(
            title: "Test Title Label",
            icon: "chevron.right",
            type: .regular
        )
        let view = viewModel.createUIView()
        
        view.assertSnapshot()
    }
}
