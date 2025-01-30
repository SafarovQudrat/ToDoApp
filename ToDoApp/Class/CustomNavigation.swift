
import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            navigationBar.prefersLargeTitles = true
        }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: animated)
            viewController.navigationItem.largeTitleDisplayMode = .always
        }
}
