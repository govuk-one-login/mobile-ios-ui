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
            "first numbered list item",
            GDSLocalisedString(
                stringLiteral: "second numbered list item",
                stringAttributes: [("list item", [.font: DesignSystem.Font.Base.bodyBold])]
            ),
            "third numbered list item",
            "fourth numbered list item"
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
            "first bulleted list item",
            GDSLocalisedString(
                stringLiteral: "second bulleted list item",
                stringAttributes: [("list item", [.font: DesignSystem.Font.Base.bodyBold])]
            ),
            "third bulleted list item",
            "fourth bulleted list item"
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


