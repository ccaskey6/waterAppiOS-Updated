//
//  GraphViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 4/19/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Pods_waterReportApp
import Charts
import Firebase

class LineChartViewController: UIViewController, ChartViewDelegate {

    private static var currentChart: String = ""
    private static var chartData: String = ""
    
    @IBOutlet weak var lineChartView: LineChartView!
    let monthNumbers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let data: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(dataPoints: monthNumbers, values: data)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [Int], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(dataPoints[i]), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: LineChartViewController.getChartData() + " Trends")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet as IChartDataSet)
        lineChartView.data = lineChartData
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public static func setCurrentChart(chartType: String) {
        currentChart = chartType
    }
    
    public static func getCurrentChart() -> String {
        return currentChart
    }
    
    public static func setChartData(data: String) {
        chartData = data;
    }
    
    public static func getChartData() -> String {
        return chartData
    }

}
