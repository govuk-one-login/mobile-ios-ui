@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSOrientationLockingTabBarControllerTests {
    let sut = GDSOrientationLockingTabBarController()
    let navigationController = UINavigationController()
    let orientationLockingViewController = MockOrientationLockingViewController()
    let viewController = UIViewController()
    
    // MARK: For the following tests result of OrientationLockingTabBarController should match OrientationLockingViewController
    @Test("Screen should not autorotate")
    func test_shouldNotAutorotate() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController

        let orientationLockingViewController = MockOrientationLockingViewController(shouldAutorotate: false)
        
        // Present OrientationLockingViewController modally
        navigationController.present(orientationLockingViewController, animated: false)
        
        // TabBarController rotation should match MockOrientationLockingViewController rotation
        #expect(sut.shouldAutorotate == false)
    }
    
    @Test("Screen should autorotate")
    func test_shouldAutorotate() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        let orientationLockingViewController = MockOrientationLockingViewController(shouldAutorotate: true)
        
        // Present OrientationLockingViewController modally
        navigationController.present(orientationLockingViewController, animated: true)
        
        // TabBarController rotation should match MockOrientationLockingViewController rotation
        #expect(sut.shouldAutorotate == true)
    }
    
    @Test("Screens preferredInterfaceOrientationForPresentation should match mock")
    func test_preferredInterfaceOrientationForPresentation() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present OrientationLockingViewController modally
        navigationController.present(orientationLockingViewController, animated: false)
        
        // TabBarController rotation should match MockOrientationLockingViewController rotation
        #expect(sut.preferredInterfaceOrientationForPresentation == .landscapeLeft)
    }
    
    @Test("Screens supportedInterfaceOrientations should match mock")
    func test_supportedInterfaceOrientations() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present OrientationLockingViewController modally
        navigationController.present(orientationLockingViewController, animated: false)
        
        // TabBarController rotation should match MockOrientationLockingViewController rotation
        #expect(sut.supportedInterfaceOrientations == .landscapeLeft)
    }
    
    @Test("Screens preferredStatusBarStyle should match mock")
    func test_preferredStatusBarStyle() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present OrientationLockingViewController modally
        navigationController.present(orientationLockingViewController, animated: false)
        
        // TabBarController rotation should match MockOrientationLockingViewController rotation
        #expect(sut.preferredStatusBarStyle == .darkContent)
    }
    
    // MARK: For the following tests result of OrientationLockingTabBarController should match default behaviour of UITabBarController
    @Test("Test default screen rotation")
    func test_default_shouldAutorotate() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present a UIViewController modally
        navigationController.present(viewController, animated: false)
        
        #expect(sut.shouldAutorotate == UITabBarController().shouldAutorotate)
    }
    
    @Test("Test default preferredInterfaceOrientationForPresentation")
    func test_default_preferredInterfaceOrientationForPresentation() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present a UIViewController modally
        navigationController.present(viewController, animated: false)
        
        // Since the UIViewController is being presented modally
        // This value value will not be set and will be .unknown
        #expect(sut.preferredInterfaceOrientationForPresentation == .unknown)
    }
    
    @Test("Test default supportedInterfaceOrientations")
    func test_default_supportedInterfaceOrientations() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present a UIViewController modally
        navigationController.present(viewController, animated: false)
        
        #expect(sut.supportedInterfaceOrientations == UITabBarController().supportedInterfaceOrientations)
    }
    
    @Test("Test default preferredStatusBarStyle")
    func test_default_preferredStatusBarStyle() {
        sut.setViewControllers([navigationController], animated: true)
        sut.attachToWindow()
        sut.selectedViewController = navigationController
        
        // Present a UIViewController modally
        navigationController.present(viewController, animated: false)
        
        #expect(sut.preferredStatusBarStyle == UITabBarController().preferredStatusBarStyle)
    }
}

class MockOrientationLockingViewController: UINavigationController, GDSOrientationLockingNavigationController {
    let shouldAutorotateValue: Bool
    
    init(shouldAutorotate: Bool = false) {
        shouldAutorotateValue = shouldAutorotate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        shouldAutorotateValue
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeLeft
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscapeLeft
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}
