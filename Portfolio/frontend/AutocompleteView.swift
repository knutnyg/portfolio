
import Foundation
import UIKit
import SnapKit

class AutocompleteView : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    var searchBar:UISearchBar!
    var tableView:UITableView!

    var searchActive:Bool!
    var tickers:[String]!

    var tableViewContraints:ComponentWrapper!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar()
        searchBar.delegate = self
        searchActive = false

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true

        view.addSubview(searchBar)
        view.addSubview(tableView)

        tableViewContraints = ComponentWrapper(view: tableView, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop(searchBar.snp_bottom))

        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: searchBar, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().marginTop(100)),
                tableViewContraints
        ]
        SnapKitHelpers.setConstraints(components)
    }


    func filteredTickers() -> [String]{
        return tickers.filter{(ticker:String) in ticker.containsString(searchBar.text!)}
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(filteredTickers().count == 0){
            searchActive = false;
        } else {
            searchActive = true;
            tableView.hidden = false
            updateContraints()
        }
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func updateContraints(){
        tableViewContraints = ComponentWrapper(view: tableViewContraints.view, rules: tableViewContraints.rules.height(filteredTickers().count * 30))
        SnapKitHelpers.updateConstraints([tableViewContraints])
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {

            return filteredTickers().count
        }
        return 0;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(false, completion: nil)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if searchActive == true{
            cell.textLabel?.text = filteredTickers()[indexPath.row]
        } else {
            cell.textLabel?.text = "default";
        }

        return cell;
    }
}
