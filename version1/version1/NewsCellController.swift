import Foundation
import UIKit
import TTTAttributedLabel

class NewsCellController: UITableViewCell,TTTAttributedLabelDelegate {
    
    
    

    @IBOutlet weak var title: TTTAttributedLabel!


    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var publisher: UILabel!
   
    @IBOutlet weak var date: UILabel!
    
}

