
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homView = Bundle.main.loadNibNamed("HomeView3", owner: self, options: nil)?.first as! HomeView3
        homView.layoutIfNeeded()
        homView.frame = self.topView.bounds
        self.topView.addSubview(homView)
    }
    
}
