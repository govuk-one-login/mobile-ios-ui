import DesignSystem
import UIKit

class ViewController: UIViewController {
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
    
    lazy var button: UIButton = {
        let viewmodel = GDSButtonViewModel(
            title: TitleForState(normal: "My really very long button title"),
            icon: .arrowUpRight,
            style: .primary,
            buttonAction: .asyncAction(
                { [unowned self] in
                    do {
                        print("button tapped")
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        print("button await completed")
                    } catch {
                        
                    }
                }
            ),
            haptic: .success
        )
        
        let result = GDSButton(
            viewModel: viewmodel
        )
        
        return result
    }()
    
    lazy var button2: UIButton = {
        let viewmodel = GDSButtonViewModel(
            title: TitleForState(normal: "My really very long button title"),
            icon: .arrowUpRight,
            style: .primaryLarge,
            buttonAction: .asyncAction(
                { [unowned self] in
                    do {
                        print("button tapped")
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        print("button await completed")
                    } catch {
                        
                    }
                }
            ),
            haptic: .impactHeavy
        )
        
        let result = GDSButton(
            viewModel: viewmodel
        )
        
        return result
    }()
    
    lazy var button3: UIButton = {
        let viewmodel = GDSButtonViewModel(
            title: TitleForState(normal: "My button title"),
            icon: .arrowUpRight,
            style: .secondarySmallLeading,
            buttonAction: .action(
                { [unowned self] in
                    print("button tapped")
                }
            )
        )
        
        let result = GDSButton(
            viewModel: viewmodel
        )
        
        return result
    }()
    
    lazy var button4: UIButton = {
        let viewmodel = GDSButtonViewModel(
            title: TitleForState(normal: "My button title"),
            icon: .arrowUpRight,
            style: .secondarySmallLeading,
            buttonAction: .asyncAction(
                { [unowned self] in
                    do {
                        print("button tapped")
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        print("button await completed")
                    } catch {
                        
                    }
                }
            )
        )
        
        let result = GDSButton(
            viewModel: viewmodel
        )
        
        return result
    }()
    
    lazy var button5: UIButton = {
        let viewmodel = GDSButtonViewModel(
            title: TitleForState(normal: "My button title"),
            icon: .qrCode,
            style: .secondary,
            buttonAction: .action(
                { [unowned self] in
                    print("button tapped")
                }
            )
        )
        
        let result = GDSButton(
            viewModel: viewmodel
        )
        
        return result
    }()
    
    func addHapticButtons() {
        Haptic.allCases.forEach { haptic in
            let viewModel = GDSButtonViewModel(
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
            let button = GDSButton(viewModel: viewModel)
            stackview.addArrangedSubview(button)
        }
    }
    
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
        stackview.addArrangedSubview(button)
        stackview.addArrangedSubview(button2)
        stackview.addArrangedSubview(button3)
        stackview.addArrangedSubview(button4)
        stackview.addArrangedSubview(button5)
        addHapticButtons()
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

