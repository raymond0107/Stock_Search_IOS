import Foundation
import UIKit
import Alamofire

class DetailViewController: UIViewController {
    

    var stockSymbol: String = String()
    var stockCandidate: [StockCandidate] = []
   
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func Current(sender: UIButton) {
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("current")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        
        self.currentViewController = newViewController
    }
  
    
    @IBAction func Historial(sender: UIButton) {
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("historial")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
    
        self.currentViewController = newViewController
    }
    
    
    @IBAction func News(sender: UIButton) {
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("news")
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("current")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = stockSymbol
        //print(stockSymbol)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
    
}