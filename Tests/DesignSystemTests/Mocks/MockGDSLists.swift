import DesignSystem
import UIKit

struct MockNumberedListViewModel: GDSListViewModel {
    typealias ViewType = GDSListView<MockNumberedListViewModel>
    
    var verticalPadding: VerticalPadding? = nil
    var horizontalPadding: HorizontalPadding? = nil
    
    var title: GDSLocalisedString?
    var titleConfig: TitleConfig?
    var items: [GDSLocalisedString]
    var style: ListStyle = .numbered
    
    init(
        title: GDSLocalisedString? = "Test numbered list view",
        titleConfig: TitleConfig? = (font: DesignSystem.Font.Base.headline, isHeader: true),
        items: [GDSLocalisedString] = [
            "first numbered list element",
            GDSLocalisedString(
                stringLiteral: "second numbered list element",
                stringAttributes: [("numbered list", [.font: DesignSystem.Font.Base.body])]
            ),
            "third numbered list element",
            "fourth numbered list element"
        ]
    ) {
        self.title = title
        self.titleConfig = titleConfig
        self.items = items
    }
    
    public func createUIView() -> UIView {
        GDSListView(viewModel: self)
    }
}

struct MockBulletedListViewModel: GDSListViewModel {
    typealias ViewType = GDSListView<MockBulletedListViewModel>
    
    var verticalPadding: VerticalPadding? = nil
    var horizontalPadding: HorizontalPadding? = nil
    
    var title: GDSLocalisedString?
    var titleConfig: TitleConfig?
    var items: [GDSLocalisedString]
    var style: ListStyle = .bulleted
    
    init(
        title: GDSLocalisedString? = "Test bulleted list view",
        titleConfig: TitleConfig? = (font: DesignSystem.Font.Base.headline, isHeader: true),
        items: [GDSLocalisedString] = [
            "first bulleted list element",
            GDSLocalisedString(
                stringLiteral: "second bulleted list element",
                stringAttributes: [("bulleted list", [.font: DesignSystem.Font.Base.body])]
            ),
            "third bulleted list element",
            "fourth bulleted list element"
        ]
    ) {
        self.title = title
        self.titleConfig = titleConfig
        self.items = items
    }
    
    public func createUIView() -> UIView {
        GDSListView(viewModel: self)
    }
}


