import UIKit
import Alamofire
import CoreData
import MBProgressHUD
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameInput: AutoCompleteTextField!
    

    @IBAction func refresh(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(self.FavoritesTable, animated: true)
        hud.dimBackground = true
        hud.show(true)
        let delayInSeconds = 0.8
        let dealay = dispatch_time(DISPATCH_TIME_NOW,
        Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
        dispatch_after(dealay, dispatch_get_main_queue()) {
            hud.hide(true)
        }
    }
    @IBOutlet weak var FavoritesTable: UITableView!
    
    //parameters:
    private let lookUpURLString = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input="
    private var dataTask:NSURLSessionDataTask?
    private var responseData:NSMutableData?
    var favors = [Favors]()
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        configureTextField()
        handleTextFieldInterfaces()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.reload()
    }

    private func configureTextField(){
        nameInput.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        nameInput.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        nameInput.autoCompleteCellHeight = 35.0
        nameInput.maximumAutoCompleteCount = 20
        nameInput.hidesWhenSelected = true
        nameInput.hidesWhenEmpty = true
        nameInput.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        nameInput.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        nameInput.onTextChange = {[weak self] text in
        if let dataTask = self?.dataTask {
            dataTask.cancel()
        }
        self?.fetchAutocompletePlaces(text)
        }
        
        nameInput.onSelect = {[weak self] text, indexpath in
            var myStringArr = text.componentsSeparatedByString("-")
            //print(myStringArr[0])
            self!.nameInput.text = myStringArr[0]
            self!.nameInput.endEditing(true)
            //print(self!.nameInput.text!)
        }
    }
    
    private func fetchAutocompletePlaces(keyword:String) {
        Alamofire.request(.GET, "http://csci571-1272.appspot.com/?", parameters: ["find":keyword])
            .responseJSON { response in
                if let JSON = response.result.value {
                    var autoAns = [String]()
                    if (JSON.count > 0 && keyword != "") {
                        for s in JSON as! [NSDictionary]{
                            let symbol = s["Symbol"] as! String
                            let name  = s["Name"] as! String
                            let exchange = s["Exchange"] as! String
                            autoAns.append(symbol + "-" + name + "-" + exchange)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.nameInput.autoCompleteStrings = autoAns
                    })
                }
        }
    }
    
    func checkAndGetQuote (name:String, completion:(flag: Bool) -> ()) {
        var f = false
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.GET, "http://csci571-1272.appspot.com/?", parameters: ["find":name])
            .responseJSON { response in
                if let JSON = response.result.value {
                    if (JSON.count > 0) {
                        for s in JSON as! [NSDictionary]{
                            if (name == s["Symbol"] as! String) {
                                f = true
                                break
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion(flag:f)
                }
            }
        }
    }
    
    @IBAction func getQuote(sender: UIButton) {
        let _name = nameInput.text;
        //testArea.text = lookUpURLString + (nameInput.text)!;
        if ((_name ?? "").isEmpty) {
            //testArea.text = _name;
            let _alertController = UIAlertController(title: "Please Enter a Stock Name or Symbol", message:
                "", preferredStyle: UIAlertControllerStyle.Alert);
            _alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(_alertController, animated: true, completion: nil);
            return
        }
        checkAndGetQuote((nameInput.text)!) { (flag) -> () in
            if (!flag) {
                let _alertController = UIAlertController(title: "Invalid Symbol", message:
                    "", preferredStyle: UIAlertControllerStyle.Alert);
                _alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(_alertController, animated: true, completion: nil);
                return
            }
            else {
                //self.performSegueWithIdentifier("getQuote", sender: self)
                let controller: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
                controller.stockSymbol = (self.nameInput.text)!
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.symbol = (self.nameInput.text)!
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favors.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 102.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FavoriteCell = self.FavoritesTable.dequeueReusableCellWithIdentifier("favorCell") as! FavoriteCell
        
        let favor = favors[indexPath.row]
        cell.symbol?.text = favor.symbol
        cell.name?.text = favor.name
        cell.price?.text = favor.price
        let low_high = favor.background
        cell.change?.text = favor.change
        cell.change?.textColor = UIColor.whiteColor()
        if low_high == "low" {
            cell.change?.backgroundColor = UIColor.redColor()
        }
        else if low_high == "high" {
            cell.change?.backgroundColor = UIColor.greenColor()
        }
        else {
            cell.change?.backgroundColor = UIColor.whiteColor()
        }
        cell.mCap?.text = favor.mCap
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDel.managedObjectContext
            let request = NSFetchRequest(entityName: "Favors")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.executeFetchRequest(request)
                if results.count > 0 {
                    for res in results {
                        let symbol = res.valueForKey("symbol") as! String
                        if symbol == favors[indexPath.row].symbol {
                            context.deleteObject(res as! NSManagedObject)
                            break
                        }
                    }
                }
            }
            catch let error as NSError {
                print("\(error)")
            }
            appDel.saveContext()
            self.reload()
            self.FavoritesTable.reloadData()
        }
    }
    func reload() {
        let request = NSFetchRequest(entityName: "Favors")
        do {
            favors = try context.executeFetchRequest(request) as! [Favors]
            self.FavoritesTable.reloadData()
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FavoriteCell {
            let controller: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
            controller.stockSymbol = (cell.symbol?.text)!
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.symbol = (cell.symbol?.text)!
            self.navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        return
    }
}

