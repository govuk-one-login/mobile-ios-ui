import DesignSystem
import UIKit

class ViewController: UIViewController {
    
    lazy var stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        stackview.spacing = DesignSystem.Spacing.default
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layoutMargins = .init(
            top: DesignSystem.Spacing.default,
            left: DesignSystem.Spacing.default,
            bottom: DesignSystem.Spacing.default,
            right: DesignSystem.Spacing.default
        )
        return stackview
    }()
    
    lazy var button1: UIButton = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackview)
        configureConstraints()
        addViewsToStack()
    }
    
    func addViewsToStack() {
        let spacer1 = UIView()
        let spacer2 = UIView()
        
        stackview.addArrangedSubview(spacer1)
        stackview.addArrangedSubview(button1)
        stackview.addArrangedSubview(button2)
        stackview.addArrangedSubview(spacer2)
    }
    
    func configureConstraints() {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                stackview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                stackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                stackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ]
        )
    }
}

