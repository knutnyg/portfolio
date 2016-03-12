
import Foundation
import UIKit
import SnapKit

class AutocompleteView : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    var searchBar:UISearchBar!
    var tableView:UITableView!
    var delegate:AutocompleteViewDelegate!

    var searchActive:Bool!
    var data:[AutocompleteDataItem]!

    var tableViewContraints:ComponentWrapper!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar()
        searchBar.delegate = self
        searchActive = false

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(searchBar)
        view.addSubview(tableView)

        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: searchBar, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().height(35)),
                ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop(searchBar.snp_bottom).snapBottom())
        ]
        SnapKitHelpers.setConstraints(components)
    }

    func filteredTickers() -> [AutocompleteDataItem]{
        return data.filter{ (dataItem:AutocompleteDataItem) in dataItem.text.lowercaseString.containsString(searchBar.text!.lowercaseString)}
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        self.tableView.hidden = false
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.updateAutocompleteConstraints(filteredTickers().count)
        self.tableView.hidden = false
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filteredTickers().count
        }
        return 0;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.text = filteredTickers()[indexPath.item].text
        self.tableView.hidden = true
        delegate.updateAutocompleteConstraints(0)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        if searchActive == true{
            cell.textLabel?.text = filteredTickers()[indexPath.row].text
            cell.detailTextLabel?.text = filteredTickers()[indexPath.row].detail
        } else {
            cell.textLabel?.text = "default";
        }
        return cell;
    }
}
