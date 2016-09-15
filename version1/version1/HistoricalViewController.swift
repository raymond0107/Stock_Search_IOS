import Foundation
import UIKit
import Alamofire

class HistoricalViewController: UIViewController{
    
    
    @IBOutlet weak var image: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let symbol = appDelegate.symbol!
        let myURL = NSURL(string: "http://cs571hw8lz-env.us-west-2.elasticbeanstalk.com/hw9.html#\(symbol)")
        let myURLRequest:NSURLRequest = NSURLRequest(URL: myURL!)
        image.loadRequest(myURLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}