import UIKit
import Charts
import SnapKit

class ViewController: UIViewController {

    var chart: LineChartView!
    var weeks:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        let portfolio = Portfolio()
        portfolio






        chart = LineChartView()
        chart

        let weeks = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let norwegian = [313, 296, 260, 250, 260, 270, 280, 290, 300]

        view.addSubview(chart)
        setChart()

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: chart, rules: ConstraintRules().horizontalFullWithMargin(view, margin: 10).snapTop(view.snp_top).snapBottom(view.snp_bottom))]

        SnapKitHelpers.setConstraints(view, components: comp)

        // Do any additional setup after loading the view, typically from a nib.
    }

    func setChart() {
        chart.noDataText = "You must give me the datas!"

        let values = [
                ChartDataEntry(value: 22000, xIndex: 0),
                ChartDataEntry(value: 21345, xIndex: 1),
                ChartDataEntry(value: 20022, xIndex: 2),
                ChartDataEntry(value: 20300, xIndex: 3),
                ChartDataEntry(value: 21344, xIndex: 4),
                ChartDataEntry(value: 22323, xIndex: 5),
                ChartDataEntry(value: 19002, xIndex: 6),
                ChartDataEntry(value: 18234, xIndex: 7),
                ChartDataEntry(value: 23000, xIndex: 8)]

        let dataset = [LineChartDataSet(yVals: values, label: "test")]

        let data = LineChartData(xVals: weeks, dataSets: dataset)

        chart.data = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

