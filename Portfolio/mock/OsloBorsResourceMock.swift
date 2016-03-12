
import Foundation
import BrightFutures

class OsloBorsResourceMock : OsloBorsResource {

    override func allStockInformation(store: Store) -> Future<AllStockInfo, NSError> {
        return Future(value: AllStockInfo())
    }


}
