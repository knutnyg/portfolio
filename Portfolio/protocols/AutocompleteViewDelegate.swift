
import Foundation

protocol AutocompleteViewDelegate {

    func updateAutocompleteConstraints(rows:Int) -> Void
    func userSelectedItem(item:String) -> Void
}
