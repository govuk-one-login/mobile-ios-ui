import DesignSystem
import UIKit

public struct TestViewControllerViewModel: ScreenViewModel {
    public let content: [ContentItem]
    public var moveableFooter: [ContentItem]
    public var footer: [ContentItem]
    
}

class ViewController: UIViewController {
    var viewModel: TestViewControllerViewModel {
        let hapticButtons = Haptic.allCases.map { haptic in
            GDSButtonViewModel(
                title: TitleForState(normal: String(describing: haptic)),
                icon: nil,
                style: .primary,
                buttonAction: .action(
                    {
                        print(String(describing: haptic))
                    }
                ),
                haptic: haptic
            )
        }
        
        return TestViewControllerViewModel(
            content: [
                GDSButtonViewModel(
                    title: TitleForState(normal: "My really very long button title"),
                    icon: IconForState.arrowUpRight,
                    style: .primary,
                    buttonAction: .asyncAction(
                        {
                            do {
                                print("button tapped")
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                print("button await completed")
                            } catch {
                                
                            }
                        }
                    ),
                    haptic: .success
                ),
                
                GDSButtonViewModel(
                    title: TitleForState(normal: "My really very long button title"),
                    icon: IconForState.arrowUpRight,
                    style: .primaryLarge,
                    buttonAction: .asyncAction(
                        {
                            do {
                                print("button tapped")
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                print("button await completed")
                            } catch {
                                
                            }
                        }
                    ),
                    haptic: .impactHeavy
                ),
                
                GDSButtonViewModel(
                    title: TitleForState(normal: ""),
                    icon: IconForState.arrowUpRight,
                    style: .primaryLarge,
                    buttonAction: .asyncAction(
                        {
                            do {
                                print("button tapped")
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                print("button await completed")
                            } catch {
                                
                            }
                        }
                    ),
                    haptic: .impactHeavy
                ),
                
                GDSButtonViewModel(
                    title: TitleForState(normal: "My button title"),
                    icon: IconForState(
                        normal: IconStyle(icon: "chevron.up.circle", position: .leading),
                        selected: IconStyle(icon: "chevron.down.circle", position: .leading)
                    ),
                    style: .secondarySmallLeading,
                    buttonAction: .action(
                        {
                            print("button tapped")
                        }
                    )
                ),
                
                GDSButtonViewModel(
                    title: TitleForState(normal: "My button title"),
                    icon: IconForState.arrowUpRight,
                    style: .secondarySmallLeading,
                    buttonAction: .asyncAction(
                        {
                            do {
                                print("button tapped")
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                print("button await completed")
                            } catch {
                                
                            }
                        }
                    )
                ),
                
                GDSButtonViewModel(
                    title: TitleForState(normal: "My button title"),
                    icon: IconForState.qrCode,
                    style: .secondary,
                    buttonAction: .action(
                        {
                            print("button tapped")
                        }
                    )
                )
                
            ]
            + hapticButtons,
            
            moveableFooter: [],
            footer: []
        )
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        stackview.spacing = 16
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layoutMargins = .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        return stackview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        scrollView.addSubview(stackview)
        view.addSubview(scrollView)
        configureConstraints()
        addViewsToStack()
        
        
    }
    
    func addViewsToStack() {
        let spacer1 = UIView()
        let spacer2 = UIView()
        
        stackview.addArrangedSubview(spacer1)
        
        viewModel.content.forEach {
            stackview.addArrangedSubview($0.uiView)
        }

        stackview.addArrangedSubview(spacer2)
    }
    
    func configureConstraints() {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                stackview.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
                stackview.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor ),
                stackview.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                stackview.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            ]
        )
    }
}

