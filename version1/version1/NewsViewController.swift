import UIKit
import Foundation
import Alamofire
import  TTTAttributedLabel

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TTTAttributedLabelDelegate {
    
    var stockNews: [StockNews] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let symbol = appDelegate.symbol!
        StockKit.fetchStocksNews(symbol) {(stockNews) -> () in
            self.stockNews = stockNews
            self.table.reloadData()
        }
        self.table.estimatedRowHeight = 80;
        self.table.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockNews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NewsCellController = self.table.dequeueReusableCellWithIdentifier("cell")! as! NewsCellController
       
  
        cell.title.text = self.stockNews[indexPath.row].title
      
        cell.content.text = self.stockNews[indexPath.row].content
        cell.publisher.text = self.stockNews[indexPath.row].publisher
        let arr = (self.stockNews[indexPath.row].date)!.componentsSeparatedByString("T")
        let date = arr[0]
        let time = (arr[1]).componentsSeparatedByString("Z")
        let hour = time[0].componentsSeparatedByString(":")
        let d = date + " " + hour[0] + ":" + hour[1]
        //print(arr)
        cell.date.text = d
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = self.stockNews[indexPath.row].url{
            if let urln = NSURL(string: url) {
                UIApplication.sharedApplication().openURL(urln)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        return
    }
    
}

