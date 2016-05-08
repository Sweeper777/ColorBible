import UIKit

class ColorPasserController: UINavigationController {

    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = self.topViewController as? ColorDetailsController {
            vc.color = self.color
        }
    }
}
