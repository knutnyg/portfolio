import Foundation
import UIKit
import SnapKit

class AutocompleteViewFull: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var searchBar: UISearchBar!
    var tableView: UITableView!
    var delegate: AutocompleteViewDelegate!

    var searchActive: Bool!
    var data: [AutocompleteDataItem]!
    var visibleData: [AutocompleteDataItem]!

    var tableViewContraints: ComponentWrapper!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)

        searchBar = UISearchBar()
        searchBar.delegate = self
        searchActive = false

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        let touch = UITapGestureRecognizer(target:self, action:"dismiss:")
        view.addGestureRecognizer(touch)
        touch.delegate = self

        view.addSubview(searchBar)
        view.addSubview(tableView)

        visibleData = limit(filter(data), count: 6)


        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: searchBar, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().marginTop(200).height(50)),
                ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop(searchBar.snp_bottom).height(0)),
        ]
        SnapKitHelpers.setConstraints(components)
    }

    func filter(data:[AutocompleteDataItem]) -> [AutocompleteDataItem] {
        return data
        .filter {
            (dataItem: AutocompleteDataItem) in "\(dataItem.text.lowercaseString) \(dataItem.detail.lowercaseString)".containsString(searchBar.text!.lowercaseString)
        }
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(touch.view == view) {
            return true
        } else {
            return false
        }
    }

    func dismiss(sender: UITapGestureRecognizer){
            self.dismissViewControllerAnimated(false, completion: nil)
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
                ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(8).snapTop(searchBar.snp_bottom).height(35*tableHeight))
        ])
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
        dismissViewControllerAnimated(false, completion: nil)

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
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
}
