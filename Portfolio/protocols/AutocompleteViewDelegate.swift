
import Foundation

protocol AutocompleteViewDelegate {

    func userSelectedItem(item:String) -> Void
    func hideSubComponents() -> Void
    func showSubComponents() -> Void
}
