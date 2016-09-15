import Foundation
import UIKit
import Alamofire

class ContentViewController: UIViewController {
    
    @IBOutlet weak var titleLael: UILabel!
    
    var pageIndex: Int!
    var titleText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLael.text = self.titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
