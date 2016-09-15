import UIKit

public class AutocompleteStringDataSource: NSObject, AutocompleteDataSource {
    
    var items :[String] = []
    
    public override init() {
        super.init()
    }
    
    public init(items:[String]) {
        self.items = items
        super.init()
    }
    
    public func itemsForText(text: String) -> [String] {
        return filterItems(text)
    }
    
    private func filterItems(text:String) -> [String] {
        var filteredItems : [String] = []
        for item in items {
            if item.lowercaseString.hasPrefix(text.lowercaseString) {
                filteredItems.append(item)
            }
        }
        return filteredItems
    }
    
}