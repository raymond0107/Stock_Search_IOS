import UIKit

public class AutocompleteTableView: UITableView, UITableViewDataSource, AutocompleteResultsView, UITableViewDelegate {
    
    public var items:[String] = [] {
        didSet {
            self.reloadData()
        }
    }
    public var keyword:String = ""
    public var selectionDelegate:AutocompleteResultsViewDelegate?
    public var view: UIView {
        get {
            return self
        }
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 5
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        let item = items[indexPath.row]
        let text = NSMutableAttributedString(string: item)
        let font = UIFont.boldSystemFontOfSize(cell.textLabel!.font.pointSize)
        text.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: keyword.characters.count))
        cell.textLabel!.attributedText = text
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        selectionDelegate?.resultsView(self, didSelectItem: item)
    }
    
}
