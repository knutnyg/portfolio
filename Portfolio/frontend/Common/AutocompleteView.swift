import Foundation
import UIKit
import SnapKit

class AutocompleteView: ModalViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var searchBar: UISearchBar!
    var tableView: UITableView!
    var delegate: AutocompleteViewDelegate!

    var searchActive: Bool!
    var data: [AutocompleteDataItem]!
    var visibleData: [AutocompleteDataItem]!
    var store:Store

    init(store:Store, callback:(()->Void)?){
        self.store = store
        self.data = store.allStockInfo.getTickersForAutocomplete()
        super.init(nibName: nil, bundle: nil)
        self.callback = callback
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        height = 300

        searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.placeholder = "Search"

        searchBar.translucent = false
        searchBar.delegate = self
        searchActive = false

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(searchBar)
        view.addSubview(tableView)

        visibleData = limit(filter(data), count: 6)


        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: searchBar, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().height(35)),
                ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop(searchBar.snp_bottom).snapBottom())
        ]
        SnapKitHelpers.setConstraints(components)
    }

    func filter(data:[AutocompleteDataItem]) -> [AutocompleteDataItem] {
        return data
        .filter {
            (dataItem: AutocompleteDataItem) in "\(dataItem.text.lowercaseString) \(dataItem.detail.lowercaseString)".containsString(searchBar.text!.lowercaseString)
        }
    }

    func limit(input:[AutocompleteDataItem], count:Int) -> [AutocompleteDataItem] {
        var limited:[AutocompleteDataItem] = []

        for var i = 0; i < input.count; i++ {
            if i < count {
                limited.append(input[i])
            }
        }
        return limited
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        self.tableView.hidden = false
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        visibleData = limit(filter(data), count: 6)
        updateTableHeight()
        self.tableView.hidden = false
        self.tableView.reloadData()
    }

    func updateTableHeight(){
        let tableHeight = min(visibleData.count, 6)
        SnapKitHelpers.updateConstraints([
                ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(8).snapTop(searchBar.snp_bottom).height(30*tableHeight))
        ])
        if tableHeight > 0 {
            delegate.hideSubComponents()
        } else {
            delegate.showSubComponents()
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return visibleData.count
        }
        return 0;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.text = visibleData[indexPath.item].text
        self.tableView.hidden = true
        delegate.userSelectedItem(visibleData[indexPath.item].text)
        delegate.showSubComponents()
    }



    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        if searchActive == true {
            cell.textLabel?.text = visibleData[indexPath.row].text
            cell.detailTextLabel?.text = visibleData[indexPath.row].detail
        } else {
            cell.textLabel?.text = "default";
        }
        return cell;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
