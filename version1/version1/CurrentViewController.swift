import UIKit
import Foundation
import FBSDKShareKit
import CoreData
//import SDWebImage

class CurrentViewController: UITableViewController {
    var favorated = false
    var favors = [Favors]()
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var f: UIButton!
    
    @IBAction func facebook(sender: AnyObject) {
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = self.shareContent
        dialog.mode = FBSDKShareDialogMode.FeedBrowser
        dialog.delegate = self
        dialog.show()
    }
    @IBAction func favorite(sender: AnyObject) {
        print("click favorite")
        if (favorated) {
            favorated = !favorated
            f.setImage(UIImage(named: "favorite1"), forState: UIControlState.Normal)
        }
        else {
            favorated = !favorated
            f.setImage(UIImage(named: "favorite2"), forState: UIControlState.Normal)
        }
        
        favorated = true
        f.setImage(UIImage(named: "favorite1"), forState: UIControlState.Normal)
            
        let favor = NSEntityDescription.entityForName("Favors", inManagedObjectContext: context)
        
        let favorite = Favors(entity: favor!, insertIntoManagedObjectContext: context)
        
        favorite.symbol = self.symbol.text!
        favorite.name = self.name.text!
        favorite.price = self.last_price.text!
        
        favorite.mCap = "Market Cap: \(self.market_cap.text!)"
        let s = self.change.text!.componentsSeparatedByString("(")
        if Double(s[0]) < 0 {
            favorite.change = self.change.text!
            favorite.background = "low"
        }
        else {
            favorite.change = "+\(self.change.text!)"
            favorite.background = "high"
        }
        
        do {
            try context.save()
        }
        catch _ as NSError {
            print("Error")
        }
        
        
    }
    var stockCandidate: [StockDetails] = []
    var shareContent = FBSDKShareLinkContent()
    @IBOutlet weak var ytd_img: UIImageView!

    @IBOutlet weak var change_img: UIImageView!
    @IBOutlet weak var imgae1: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var last_price: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var time_and_date: UILabel!
    @IBOutlet weak var market_cap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var change_ytd: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var open: UILabel!
    
    override func viewDidLoad() {
        
        if getStock(self.symbol.text!) {
            f.setImage(UIImage(named: "favorite1"), forState: UIControlState.Normal)
        } else {
            f.setImage(UIImage(named: "favorite2"), forState: UIControlState.Normal)
        }

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let symbol = appDelegate.symbol!
        StockKit.fetchStocksSymbol(symbol) {(stockDetailsArray) -> () in
            self.stockCandidate = stockDetailsArray
            if (self.stockCandidate.count == 0) {
                let _alertController = UIAlertController(title: "Invalid Symbol", message:
                    "", preferredStyle: UIAlertControllerStyle.Alert);
                _alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(_alertController, animated: true, completion: nil);
                
                return
            }
            self.name.text = self.stockCandidate[0].name!
            self.symbol.text = self.stockCandidate[0].symbol!
            self.last_price.text = "$ " + String(format:"%.2f",self.stockCandidate[0].last_price!)
            self.change.text = String(format:"%.2f",self.stockCandidate[0].change!) + "(" + String(format:"%.2f",self.stockCandidate[0].changePercent!) + "%)"
            if (self.stockCandidate[0].change > 0) {
                self.change_img.image = UIImage(named:"up")
                self.change_img.tintColor = UIColor.greenColor()
            }
            else {
                self.change_img.image = UIImage(named:"down")
                self.change_img.tintColor = UIColor.redColor()
            }
            let arr = (self.stockCandidate[0].time_and_date!).componentsSeparatedByString(" ")
           
            //print(self.stockCandidate[0].time_and_date!)
            let month = arr[1]
            let day = arr[2]
            let year = arr[5]
            let time = arr[3]
            let timeArr = time.componentsSeparatedByString(":")
            let hour = timeArr[0]
            let minute = timeArr[1]
            self.time_and_date.text = month + " " + day + " " + year + " " + hour + ":" + minute
            
            if(self.stockCandidate[0].market_cap! > 1000000000) {
                self.stockCandidate[0].market_cap! /= 1000000000;
                self.market_cap.text = String(format:"%.2f",self.stockCandidate[0].market_cap!) + " Billion"
            }
            else if(self.stockCandidate[0].market_cap! > 1000000) {
                self.stockCandidate[0].market_cap! /= 1000000;
                self.market_cap.text = String(format:"%.2f",self.stockCandidate[0].market_cap!) + " Million"
            }
            else {
                self.market_cap.text = String(format:"%.2f",self.stockCandidate[0].market_cap!)
            }
            
            if (self.stockCandidate[0].changeYTD > 0) {
                self.change_ytd.text = "+" + String(format:"%.2f",self.stockCandidate[0].changeYTD!) + "(" + String(format:"%.2f",self.stockCandidate[0].changeYTDPercent!) + "%)"
                self.ytd_img.image = UIImage(named:"up")
                self.ytd_img.tintColor = UIColor.greenColor()

            }
            else {
                self.change_ytd.text = String(format:"%.2f",self.stockCandidate[0].changeYTD!) + "(" + String(format:"%.2f",self.stockCandidate[0].changeYTDPercent!) + "%)"
                self.ytd_img.image = UIImage(named:"down")
                self.ytd_img.tintColor = UIColor.redColor()
            }
            self.volume.text = String(format:"%.0f",self.stockCandidate[0].volume!)
            self.high.text = "$ " + String(format:"%.2f",self.stockCandidate[0].high_price!)
            self.low.text = "$ " + String(format:"%.2f",self.stockCandidate[0].low_price!)
            self.open.text = "$ " + String(format:"%.2f",self.stockCandidate[0].open_price!)
            

            self.shareContent.contentTitle = "Current Stock Price of " + self.stockCandidate[0].name! + " is "+String(format:"%.2f",self.stockCandidate[0].last_price!)
            self.shareContent.contentDescription =
                "Stock Information of " + self.stockCandidate[0].name!+" ("+self.stockCandidate[0].symbol!+")"
            //self.shareContent.imageURL = NSURL(string:self.url!)!
            let linkedURL = "http://finance.yahoo.com/q?s="+self.stockCandidate[0].symbol!
            self.shareContent.contentURL = NSURL(string:linkedURL)
        }
        
        let url = NSURL(string: "http://chart.finance.yahoo.com/t?s=\(symbol)&lang=en-US&width=400&height=300")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.imgae1.image = UIImage(data: data!)
        self.shareContent.imageURL = NSURL(string:"http://chart.finance.yahoo.com/t?s=\(symbol)&lang=en-US&width=400&height=300")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getStock(symbol: String) -> Bool {
        for s in self.favors{
            print(s)
            if(symbol.isEqual(s.valueForKey("symbol") as! String)) {
                return true
            }
        }
        return false
    }
}

extension CurrentViewController: FBSDKSharingDelegate {
    func sharerDidCancel(sharer: FBSDKSharing!) {
        let alertController = UIAlertController(title: "Post Canceled", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alertController = UIAlertController(title: "Post Failed", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if (results["postId"] == nil ){
            self.sharerDidCancel(sharer)
        } else {
            let alertController = UIAlertController(title: "Post Successflly", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}




